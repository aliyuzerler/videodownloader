//
//  AppOpenAdManagerDelegate.swift
//  VideoDownloader
//
//  Created by mac on 12/17/24.
//

import Foundation
import GoogleMobileAds


protocol AppOpenAdManagerDelegate: AnyObject {
  func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager)
}

class AppOpenAdManager: NSObject {
  let timeoutInterval: TimeInterval = 4 * 3_600
  /// The app open ad.
    var appOpenAd: AppOpenAd?
  /// Maintains a reference to the delegate.
  weak var appOpenAdManagerDelegate: AppOpenAdManagerDelegate?
  /// Keeps track of if an app open ad is loading.
  var isLoadingAd = false
  /// Keeps track of if an app open ad is showing.
  var isShowingAd = false
  /// Keeps track of the time when an app open ad was loaded to discard expired ad.
  var loadTime: Date?
  var isAdsReady = false
    
    
  static let shared = AppOpenAdManager()

  private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
    if let loadTime = loadTime {
      return Date().timeIntervalSince(loadTime) < timeoutInterval
    }
    return false
  }

  private func isAdAvailable() -> Bool {
    return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
  }

  private func appOpenAdManagerAdDidComplete() {
    appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
  }

  func loadAd() async {
    if isLoadingAd || isAdAvailable() {
      return
    }
    isLoadingAd = true

    print("Start loading app open ad.")

    do {
        appOpenAd = try await AppOpenAd.load(
            with: "ca-app-pub-9814860409600590/7099856890", request: Request())
      appOpenAd?.fullScreenContentDelegate = self
      loadTime = Date()
    } catch {
      appOpenAd = nil
      loadTime = nil
      print("App open ad failed to load with error: \(error.localizedDescription)")
    }
    isLoadingAd = false
  }

  func showAdIfAvailable() {
    if isShowingAd {
      print("App open ad is already showing.")
      return
    }
    if !isAdAvailable() {
      print("App open ad is not ready yet.")
      appOpenAdManagerAdDidComplete()
      if GoogleMobileAdsConsentManager.shared.canRequestAds {
        Task {
          await loadAd()
        }
      }
      return
    }
    if let ad = appOpenAd {
        if(Client().GetDataPriv(key: Constants.USER_SUB_STATE).contains(Constants.SUB_STATE_OK)){
            return
        }
      print("App open ad will be displayed.")
      isShowingAd = true
        ad.present(from: nil)
    }
  }
}

extension AppOpenAdManager: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
    print("App open ad is will be presented.")
  }

    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    appOpenAd = nil
    isShowingAd = false
    print("App open ad was dismissed.")
    appOpenAdManagerAdDidComplete()
    Task {
      await loadAd()
    }
  }

  func ad(
    _ ad: FullScreenPresentingAd,
    didFailToPresentFullScreenContentWithError error: Error
  ) {
    appOpenAd = nil
    isShowingAd = false
    print("App open ad failed to present with error: \(error.localizedDescription)")
    appOpenAdManagerAdDidComplete()
    Task {
      await loadAd()
    }
  }
}

