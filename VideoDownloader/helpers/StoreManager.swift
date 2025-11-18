//
//  StoreManager.swift
//  VideoDownloader
//
//  Created by mac on 12/17/24.
//


import SwiftUI
import StoreKit

@MainActor
class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var products: [SKProduct] = []
    @Published var isLoading: Bool = false
    @Published var purchaseSuccessful: Bool = false
    @Published var isProcessing: Bool = false
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    private var productIDs2 = [Constants.WEEKLY_SUBID]
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }
    
    func fetchProducts() {
        isLoading = true
        let request = SKProductsRequest(productIdentifiers: Set(productIDs2))
        request.delegate = self
        request.start()
    }
    
    nonisolated func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        Task { @MainActor in
            self.products = response.products
            self.isLoading = false
            
            // Geçersiz ürün ID'lerini kontrol et
            if !response.invalidProductIdentifiers.isEmpty {
                let invalidIDs = response.invalidProductIdentifiers.joined(separator: ", ")
                print("⚠️ Geçersiz Ürün ID'leri: \(invalidIDs)")
                self.errorMessage = "Ürün bulunamadı. Lütfen App Store Connect'te '\(invalidIDs)' ID'li ürünün yapılandırıldığından emin olun."
                self.isError = true
            } else {
                print("✅ Store Products: \(response.products.count)")
            }
        }
    }
    
    nonisolated func request(_ request: SKRequest, didFailWithError error: Error) {
        Task { @MainActor in
            self.isLoading = false
            self.isError = true
            let errorDescription = error.localizedDescription
            print("❌ Ürün isteği başarısız: \(errorDescription)")
            
            // Hata mesajını Türkçe ve anlaşılır hale getir
            if errorDescription.contains("payment") || errorDescription.contains("Payment") {
                self.errorMessage = "Ödeme alanı hatası. Lütfen App Store Connect'te abonelik yapılandırmasını kontrol edin."
            } else if errorDescription.contains("network") || errorDescription.contains("Network") {
                self.errorMessage = "Ağ bağlantı hatası. İnternet bağlantınızı kontrol edin."
            } else if errorDescription.contains("store") || errorDescription.contains("Store") {
                self.errorMessage = "App Store bağlantı hatası. Lütfen daha sonra tekrar deneyin."
            } else {
                self.errorMessage = "Ürün bilgileri alınamadı: \(errorDescription)"
            }
        }
    }
    
    func purchase(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            isProcessing = true
            isError = false
            errorMessage = ""
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            isError = true
            errorMessage = "Bu cihazda ödeme yapılamıyor. Lütfen cihazınızın ödeme ayarlarını kontrol edin."
            print("❌ Ödeme yapılamıyor: Cihaz ödeme yapmaya izin vermiyor")
        }
    }
    
    func getProductPrice(id: String) -> SKProduct? {
        // Tam eşleşme kullan (contains yerine ==)
        // contains yanlış eşleşmelere yol açabilir (örn: remove_ads_new_2 de eşleşebilir)
        return products.first(where: { $0.productIdentifier == id })
    }
    
    func getProductPrice2(id: String) -> String {
        // Tam eşleşme kullan (contains yerine ==)
        products.first { $0.productIdentifier == id }.map { product in
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceLocale
            return formatter.string(from: product.price) ?? "N/A"
        } ?? "N/A"
    }
    
    func restorePurchases() {
        isProcessing = true
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    nonisolated func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        Task { @MainActor in
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchasing:
                    // Ödeme işlemi başlatıldı, fakat tamamlanmadı
                    print("Purchasing... Transaction in progress.")
                    isProcessing = true
                    break
                    
                case .purchased:
                    // Ödeme başarıyla tamamlandı
                    purchaseSuccessful = true
                    saveSubState(val: Constants.SUB_STATE_OK)
                    isProcessing = false
                    SKPaymentQueue.default().finishTransaction(transaction)
                    print("Purchase successful.")
                    
                case .restored:
                    // Satın alma başarıyla geri yüklendi
                    purchaseSuccessful = true
                    saveSubState(val: Constants.SUB_STATE_OK)
                    isProcessing = false
                    SKPaymentQueue.default().finishTransaction(transaction)
                    print("Purchase restored.")
                    
                case .failed:
                    // Ödeme başarısız oldu
                    if let error = transaction.error {
                        let errorDescription = error.localizedDescription
                        print("❌ Satın alma başarısız: \(errorDescription)")
                        
                        // Hata koduna göre detaylı mesaj
                        if let skError = error as? SKError {
                            switch skError.code {
                            case .paymentCancelled:
                                self.errorMessage = "Ödeme iptal edildi."
                            case .paymentInvalid:
                                self.errorMessage = "Ödeme geçersiz. Lütfen App Store Connect'te ürün yapılandırmasını kontrol edin."
                            case .paymentNotAllowed:
                                self.errorMessage = "Ödeme yapılamıyor. Cihazınızda ödeme yapma izni yok."
                            case .storeProductNotAvailable:
                                self.errorMessage = "Ürün mevcut değil. Lütfen App Store Connect'te ürünün aktif olduğundan emin olun."
                            case .clientInvalid:
                                self.errorMessage = "İstemci geçersiz. Lütfen uygulamayı yeniden başlatın."
                            case .cloudServicePermissionDenied:
                                self.errorMessage = "Bulut servis izni reddedildi."
                            case .cloudServiceNetworkConnectionFailed:
                                self.errorMessage = "Bulut servis ağ bağlantısı başarısız."
                            case .unknown:
                                if errorDescription.contains("payment") || errorDescription.contains("Payment") {
                                    self.errorMessage = "Ödeme alanı hatası. App Store Connect'te abonelik yapılandırmasını kontrol edin:\n1. Ürün ID doğru mu? (remove_ads_new)\n2. Abonelik grubu oluşturuldu mu?\n3. Abonelik durumu 'Ready to Submit' mi?"
                                } else {
                                    self.errorMessage = "Bilinmeyen hata: \(errorDescription)"
                                }
                            @unknown default:
                                self.errorMessage = "Hata oluştu: \(errorDescription)"
                            }
                        } else {
                            if errorDescription.contains("payment") || errorDescription.contains("Payment") {
                                self.errorMessage = "Ödeme alanı hatası. App Store Connect'te abonelik yapılandırmasını kontrol edin."
                            } else {
                                self.errorMessage = "Ödeme başarısız: \(errorDescription)"
                            }
                        }
                    } else {
                        self.errorMessage = "Ödeme işlemi başarısız oldu."
                    }
                    saveSubState(val: Constants.SUB_STATE_NO)
                    isProcessing = false
                    isError = true
                    SKPaymentQueue.default().finishTransaction(transaction)
                    print("Purchase failed")
                    
                case .deferred:
                    // İşlem beklemede, örneğin kullanıcı Apple ID'yi onaylamayı bekliyor olabilir
                    print("Transaction is deferred.")
                    
                @unknown default:
                    // Bilinmeyen durum, gelecekte eklenmiş yeni bir durum olabilir
                    print("Unknown transaction state.")
                }
            }
        }
    }
    
    nonisolated func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        Task { @MainActor in
            saveSubState(val: Constants.SUB_STATE_OK)
            isProcessing = false
            isError = false
            print("Restore completed transactions finished.")
        }
    }
    
    nonisolated func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        Task { @MainActor in
            saveSubState(val: Constants.SUB_STATE_NO)
            isProcessing = false
            isError = true
            let errorDescription = error.localizedDescription
            errorMessage = "Geri yükleme başarısız: \(errorDescription)"
            print("❌ Geri yükleme başarısız: \(errorDescription)")
        }
    }
    
    func saveSubState(val: String) {
        Client().SaveDataPriv(key: Constants.USER_SUB_STATE, value: val)
    }
    
    func formattedPrice(for product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? "$0.00"
    }
}
