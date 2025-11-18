import SwiftUI
import StoreKit

struct Premium: View {
    @Environment(\.dismiss) var dcc
    
    @ObservedObject private var storeManager = StoreManager()
    @State private var moveLeftToRight = false
    @State private var isLoading = false // Yükleme durumu
    @State private var isShowPremium = false
    @State private var showAlertNeg = false
    @State private var showAlertPos = false
    @State private var mainViewToggle = false
    @State private var btnTitle = ""
    @State private var isProductLoaded = false
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Arka plan resmi
            Image("prebg") // "prebg" resmini kullanıyoruz
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5) // Tam genişlik ve 1.5/3 yüksekliği
                .clipped() // Resmi çerçeveye sığdırarak kırpıyoruz
            
            // Close butonu
            Button(action: {
                if(Client().GetDataPriv(key: Constants.IS_FIRST_LOAD).contains("1")){
                    dcc() // Kapatma işlemi
                }else{
                    Client().SaveDataPriv(key: Constants.IS_FIRST_LOAD, value: "1")
                    withAnimation {
                        mainViewToggle.toggle()
                    }
                }
                print("Close button tapped")
            }) {
                Image("back") // "back" görselini kullanıyoruz
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45) // Buton boyutları
                    .padding(10) // Butonun etrafında 10px boşluk
            }
            .position(x: 40, y: 70) // Sol üst köşeye yerleştiriyoruz

            VStack(alignment: .leading, spacing: 20) {
                // İlk seçenek
                HStack(alignment: .top, spacing: 12) {
                    Image("pre1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .padding(10)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reklamları Kaldır".localizable)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Reklamsız deneyimin tadını çıkarın!".localizable)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .layoutPriority(1)
                }
                .padding(.horizontal, 20)

                // İkinci seçenek
                HStack(alignment: .top, spacing: 12) {
                    Image("pre2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .padding(10)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("HD Video İndir".localizable)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Profil fotoğraflarını kalite kaybı olmadan indirin!".localizable)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .layoutPriority(1)
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, UIScreen.main.bounds.height * 0.5 + 20)

            VStack {
                Spacer()
                Button(action: {
                    if let product = storeManager.getProductPrice(id: Constants.WEEKLY_SUBID) {
                        isLoading = true
                        storeManager.purchase(product: product)
                    } else {
                        // Ürün henüz yüklenmemiş veya bulunamadı
                        storeManager.isError = true
                        if storeManager.products.isEmpty {
                            storeManager.errorMessage = "Ürün bilgileri yükleniyor. Lütfen bekleyin."
                        } else {
                            storeManager.errorMessage = "Ürün bulunamadı. Lütfen App Store Connect'te '\(Constants.WEEKLY_SUBID)' ID'li ürünün yapılandırıldığından emin olun."
                        }
                    }
                }) {
                    Group {
                        if isProductLoaded {
                            Text(btnTitle)
                                .font(.system(size: 19, weight: .bold))
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.2)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#F43BE1"),
                                Color(hex: "#FC1A94"),
                                Color(hex: "#F43B67"),
                                Color(hex: "#F43BE1")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                 //   .offset(x: moveLeftToRight ? 10 : -10)
                   /// .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: moveLeftToRight)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                // 3 Buton (Restore Purchase | Privacy Policy | Eula)
                HStack {
                    Button(action: {
                        isLoading = true
                        storeManager.restorePurchases()
                        print("Restore Purchase tapped")
                    }) {
                        Text("Geri Yükle".localizable)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)

                    Text("|")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://hardcodedevs.com/privacy_downloader.html")!)
                        print("Privacy Policy tapped")
                    }) {
                        Text("Gizlilik Politikası".localizable)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)

                    Text("|")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)

                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://hardcodedevs.com/downloader_eula.html")!)
                        // EULA aksiyonu
                        print("EULA tapped")
                    }) {
                        Text("EULA".localizable)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 20)
            }
            
            if isLoading {
                BlurView()
                    .ignoresSafeArea()

                VStack {
                    Spacer() // Bu Spacer, içeriklerin ekranın ortasında yer almasını sağlar.
                    
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.purple.opacity(0.2), radius: 30, x: 20, y: 10)

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.8)
                            .padding(15)
                    }
                    .frame(maxWidth: .infinity) // Circle ve ProgressView öğelerinin ortalanmasını sağlar
                    
                    Text("Purchasing...".localizable)
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                    
                    Spacer() // Alt kısımda ekstra boşluk bırakmak için Spacer kullanıyoruz.
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Vertical ve horizontal tam ortalamak için
            }

        }
        .edgesIgnoringSafeArea(.top) // Resmin üst kısmı ekranın üst kısmına kadar gider
        .onAppear {
            // İlk yükleme için kontrol
            if !storeManager.products.isEmpty {
                updateButtonTitle()
            }
        }
        .onChange(of: storeManager.products) { products in
            // Ürünler yüklendiğinde buton başlığını güncelle
            if !products.isEmpty {
                updateButtonTitle()
            }
        }
        .alert(isPresented: $showAlertNeg) {
            Alert(
                title: Text("Hata".localizable),
                message: Text(storeManager.errorMessage.isEmpty ? "Ödeme işlemi başarısız oldu".localizable : storeManager.errorMessage),
                dismissButton: .default(Text("Tamam".localizable))
            )
        }
        .alert("Başarılı".localizable, isPresented: $showAlertPos) {
            Button("Tamam".localizable, action: {
              //  dismiss()
            })
        } message: {
            Text("Satın alma işlemi başarılı. Abonesiniz.".localizable)
        }
        
        .onChange(of: storeManager.isError) { isError in
            if isError {
                showAlertNeg = true
                isLoading = false
                storeManager.isError = false // Hata durumunu sıfırlıyoruz
            }
        }

        .onChange(of: storeManager.purchaseSuccessful) { isPurchase in
            if isPurchase {
           
                isLoading = false
                showAlertPos = true
            } else if !isPurchase && !storeManager.isProcessing && isLoading {
                showAlertNeg = true
                isLoading = false
            }
        }

        .onChange(of: storeManager.isProcessing) { isProcessing in
            if !isProcessing && isLoading {
                isLoading = false
            }
        }
        .fullScreenCover(isPresented: $mainViewToggle){
            MainView()
        }
    }
    
    // Helper function: Buton başlığını güncelle
    private func updateButtonTitle() {
        if let product = storeManager.getProductPrice(id: Constants.WEEKLY_SUBID) {
            btnTitle = "Satın Al".localizable + " " + storeManager.formattedPrice(for: product) + "/" + "Haftalık".localizable
            isProductLoaded = true
        } else {
            // Ürün bulunamadı, buton başlığını güncelleme
            isProductLoaded = false
        }
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    Premium()
}
