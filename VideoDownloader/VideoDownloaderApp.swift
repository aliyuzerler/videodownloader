//
//  VideoDownloaderApp.swift
//  VideoDownloader
//
//  Created by mac on 12/17/24.
//

import SwiftUI
import MijickPopups
import UIKit


@main
struct VideoDownloaderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            Splash().registerPopups(id: .shared) { config in config
                    .vertical { $0
                        .enableDragGesture(true)
                        .tapOutsideToDismissPopup(true)
                        .cornerRadius(32)
                    }
                    .center { $0
                        .tapOutsideToDismissPopup(false)
                        .backgroundColor(Color(hex: "#0E070D"))
                    }
            }
        }
    }
}
