//
//  AdMobInterstitialManager.swift
//  VideoDownloader
//
//  Created by mac on 7/16/25.
//


import Foundation
import GoogleMobileAds
import UIKit

final class AdMobInterstitialManager: NSObject, FullScreenContentDelegate {
    static let shared = AdMobInterstitialManager()
    private var interstitial: InterstitialAd?
    private var adUnitID: String = "ca-app-pub-9814860409600590/9770978614"
    private(set) var isAdReady: Bool = false
    
    private override init() {
        super.init()
    }

    func loadAd(adUnitID: String? = nil) {
        if let newID = adUnitID {
            self.adUnitID = newID
        }
        let request = Request()
        InterstitialAd.load(with: adUnitID ?? self.adUnitID, request: request) { ad, error in
            if let error = error {
                print("Interstitial failed to load: \(error.localizedDescription)")
                self.isAdReady = false
                self.interstitial = nil
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.isAdReady = true
            print("Interstitial loaded")
        }
    }
    
    func showAd(from rootViewController: UIViewController) {
        guard let interstitial = interstitial else {
            print("Ad wasn't ready")
            return
        }
        interstitial.present(from: rootViewController)
        self.isAdReady = false
    }
    
    // MARK: - GADFullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Interstitial did dismiss")
        self.loadAd()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial did fail to present: \(error.localizedDescription)")
        self.loadAd()
    }
    
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("Interstitial clicked")
    }
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("Interstitial impression recorded")
    }
}
