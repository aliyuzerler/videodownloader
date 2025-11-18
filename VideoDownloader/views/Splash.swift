//
//  Splash.swift
//  VideoDownloader
//
//  Created by mac on 12/17/24.
//

import SwiftUI
import AppTrackingTransparency



struct Splash: View {
    
    @State var isLoadedSplash = false
    
    var body: some View {
        if isLoadedSplash {
            if(Client().GetDataPriv(key: Constants.IS_FIRST_LOAD).contains("1")){
                MainView()
            }else{
                Premium()
            }
        } else {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 140, height: 140)
                        .cornerRadius(18)
                    Spacer()
                    // Lottie animation at the bottom
                    LottieView(name: "splash")
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 44)
                }
            }
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    requestTrackingPermission()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation {
                        isLoadedSplash.toggle()
                    }
                }
            }
        }
    }
    
    func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("📊 Tracking authorized")
                case .denied:
                    print("🚫 Tracking denied")
                case .restricted:
                    print("🔒 Tracking restricted")
                case .notDetermined:
                    print("❓ Tracking not determined")
                @unknown default:
                    print("🌀 Unknown tracking status")
                }
            }
        }
    }

}



#Preview {
    Splash()
}
