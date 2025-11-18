//
//  AppDelegate.swift
//  VideoDownloader
//
//  Created by mac on 12/17/24.
//

import Foundation
import UIKit
import GoogleMobileAds
import SwiftUI

@MainActor
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    @ObservedObject private var storeManager = StoreManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MobileAds.shared.start(completionHandler: nil)
        AdMobInterstitialManager.shared.loadAd()
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(applicationDidBecomeActive),name:UIApplication.didBecomeActiveNotification, object: nil)

        
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if(!Client().GetDataPriv(key: Constants.USER_SUB_STATE).contains(Constants.SUB_STATE_OK)){
            Task{
                await AppOpenAdManager.shared.loadAd()
                AppOpenAdManager.shared.isAdsReady = true
            }
        }
    }
    
    
}
