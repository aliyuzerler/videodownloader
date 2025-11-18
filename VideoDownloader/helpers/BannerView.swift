import SwiftUI
import GoogleMobileAds

struct BannerContentView: View {
    let navigationTitle: String

    var body: some View {
        GeometryReader { geometry in
            let adSize = currentOrientationAnchoredAdaptiveBanner(width: geometry.size.width)
            
            VStack {
                Spacer()
                BannerViewRepresentable(adSize: adSize)
                    .frame(width: adSize.size.width, height: adSize.size.height)
            }
        }
        .navigationTitle(navigationTitle)
    }
}

struct BannerContentView_Previews: PreviewProvider {
    static var previews: some View {
        BannerContentView(navigationTitle: "Banner")
    }
}

struct BannerViewRepresentable: UIViewRepresentable {
    var adSize: AdSize

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: adSize)
        bannerView.adUnitID = "ca-app-pub-9814860409600590/3397141956"
        bannerView.delegate = context.coordinator
        bannerView.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
            .first

        // ✅ Yeni SDK: AdRequest() yerine Request()
        bannerView.load(Request())
        return bannerView
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        uiView.adSize = adSize
    }

    class Coordinator: NSObject, BannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("✅ Reklam başarıyla yüklendi.")
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("❌ Reklam yüklenemedi: \(error.localizedDescription)")
        }
    }
}
