//
//  MainView.swift
//  VideoDownloader
//
//  Created by mac on 12/17/24.
//

import SwiftUI
import GoogleMobileAds
import MijickPopups
import SwiftSoup
import Alamofire
import SwiftyJSON
import AVKit
import Photos

struct TiktokData: Decodable, Identifiable {
    let id: String
    let region: String
    let title: String
    let cover: URL
    let originCover: URL
    let duration: Int
    let play: URL
    let wmPlay: URL
    let hdPlay: URL
    let size: Int
    let wmSize: Int
    let hdSize: Int
    let music: URL
    let musicInfo: MusicInfo
    let playCount: Int
    let diggCount: Int
    let commentCount: Int
    let shareCount: Int
    let downloadCount: Int
    let collectCount: Int
    let createTime: Int
    let anchors: [Anchor]?
    let commerceInfo: CommerceInfo
    let commercialVideoInfo: String
    let author: Author

    enum CodingKeys: String, CodingKey {
        case id
        case region
        case title
        case cover
        case originCover = "origin_cover"
        case duration
        case play
        case wmPlay = "wmplay"
        case hdPlay = "hdplay"
        case size
        case wmSize = "wm_size"
        case hdSize = "hd_size"
        case music
        case musicInfo = "music_info"
        case playCount = "play_count"
        case diggCount = "digg_count"
        case commentCount = "comment_count"
        case shareCount = "share_count"
        case downloadCount = "download_count"
        case collectCount = "collect_count"
        case createTime = "create_time"
        case anchors
        case commerceInfo = "commerce_info"
        case commercialVideoInfo = "commercial_video_info"
        case author
    }


    
    static let sample = TiktokData(id: "", region: "", title: "#paidpartnership@alolis.id Bakalan stock di rumah terus nih buat Gala!  Yuk borong di Alfamart terdekat! Dapetin hadiahnya!! #UnlockYourFantasy #MainBarengAlolis #AlolisBagiBagiRejeki #AlolisDiAlfamart #alolisransbagirejeki", cover: URL(string: "https://p16-sign-sg.tiktokcdn.com/obj/tos-alisg-p-0037/faaa1a1773414683a10c438f23f6ff82_1696286170?lk3s=d05b14bd&x-expires=1703815200&x-signature=sUVWuPWv0vuOe8HGqV1Stxr%2F38Q%3D&s=AWEME_DETAIL&se=false&sh=&sc=dynamic_cover&l=20231228022518D6F1E1EA5A4F231A3A5E")!, originCover: URL(string: "https://p16-sign-sg.tiktokcdn.com/tos-alisg-p-0037/193d78c80c5d44a1beaa42d233e728d8_1696286169~tplv-tiktokx-360p.jpeg?lk3s=d05b14bd&x-expires=1703815200&x-signature=KX%2BGtiU6r3mUb%2FoNjoc%2BKe8amXQ%3D&s=AWEME_DETAIL&se=false&sh=&sc=feed_cover&l=20231228022705F85EB2C3638AE51D77D3")!, duration: 0, play: URL(string: "https://v16m-default.akamaized.net/51ab948a6e76b8642d035d5139aa7539/658f1673/video/tos/useast2a/tos-useast2a-ve-0068-euttp/okKImtgrTDuWYD2JAYgyIjQ8b5IflEGetnZjfe/?a=0&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C0&cv=1&br=1374&bt=687&bti=OUBzOTg7QGo6OjZAL3AjLTAzYCMxNDNg&cs=0&ds=6&ft=XE5bCqT0m7jPD12yF1yR3wUTV3yKMeF~O5&mime_type=video_mp4&qs=0&rc=NTloOmQ8ZzY0ZGlpOGk1M0BpM3A6OWY6Zmw7bTMzZjczM0BgNTQ0Li5iXjUxYy5eMy4zYSNqYW1qcjRncHJgLS1kMWNzcw%3D%3D&l=20231229125628FBBBE616C738DF89859C&btag=e00088000")!, wmPlay: URL(string: "https://v16m-default.akamaized.net/6f04f450b524383ccee567c009b9e6d5/658d3168/video/tos/alisg/tos-alisg-pve-0037c001/owkjoIlEzYALaARgwhtdA0Q6pfA1EyACxGjIyb/?a=0&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C0&cv=1&br=5630&bt=2815&bti=OUBzOTg7QGo6OjZAL3AjLTAzYCMxNDNg&cs=0&ds=3&ft=XE5bCqT0m7jPD12Fr6yR3wUTV3yKMeF~O5&mime_type=video_mp4&qs=0&rc=ZmlpaTQ2NzpnOzY6NWc0N0BpajM1Zzk6ZmxubjMzODczNEA2MTFhXjYwXzAxMjIwMGEvYSNlZ18tcjRvX2FgLS1kMS1zcw%3D%3D&l=20231228022705F85EB2C3638AE51D77D3&btag=e00088000")!, hdPlay: URL(string: "https://v16m-default.akamaized.net/4bb98340f12b250164ab58b9228e7f9b/658d9081/video/tos/alisg/tos-alisg-pv-0037c001/d3e58c60c8fa40589fc5ee88de09ecdc/?a=0&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C1&cv=1&br=5858&bt=2929&bti=OTg7QGo5QHM6OjZALTAzYCMvcCMxNDNg&ds=3&ft=XE5bCqT0m7jPD12V8EyR3wUTV3yKMeF~O5&mime_type=video_mp4&qs=13&rc=anZzZjQ6ZnY3azMzODczNEBpanZzZjQ6ZnY3azMzODczNEAuYy9ecjQwMTZgLS1kMS1zYSMuYy9ecjQwMTZgLS1kMS1zcw%3D%3D&l=20231228091249AE33823E9F16843C47B6&btag=e00048000")!, size: 0, wmSize: 0, hdSize: 0, music: URL(string: "https://sf16-ies-music-va.tiktokcdn.com/obj/ies-music-ttp-dup-us/7055516784715156270.mp3")!, musicInfo: .init(id: "", title: "What Happen", play: URL(string: "https://sf16-ies-music-va.tiktokcdn.com/obj/ies-music-ttp-dup-us/7055516784715156270.mp3")!, cover: URL(string: "https://p16-sign-va.tiktokcdn.com/tos-maliva-avt-0068/7584ceb18fa6e009470c5e6669b3272f~c5_1080x1080.jpeg?lk3s=45126217&x-expires=1703815200&x-signature=hMhXK9XSPcY4jAgjrSxr5xs7eGI%3D")!, author: "Original", original: false, duration: 0, album: ""), playCount: 0, diggCount: 0, commentCount: 0, shareCount: 0, downloadCount: 0, collectCount: 0, createTime: 0, anchors: nil, commerceInfo: .init(advPromotable: false, auctionAdInvited: false, brandedContentType: 0, withCommentFilterWords: false), commercialVideoInfo: "", author: .init(id: "", uniqueId: "dananufussi_", nickname: "Dana Nufussi", avatar: URL(string: "https://p16-sign-sg.tiktokcdn.com/tos-alisg-avt-0068/f5646c34230ffa944e471130891a67c9~c5_300x300.jpeg?lk3s=45126217&x-expires=1703815200&x-signature=I53V0kO2bgAmjplWxDcvojGeHYE%3D")!))
}

struct Anchor: Decodable {
    let id: String
    let uniqueId: String
    let nickname: String
    let avatar: URL

    enum CodingKeys: String, CodingKey {
        case id
        case uniqueId = "unique_id"
        case nickname
        case avatar
    }
}

struct MusicInfo: Decodable, Equatable, Hashable {
    let id: String
    let title: String
    let play: URL
    let cover: URL
    let author: String
    let original: Bool
    let duration: Int
    let album: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case play
        case cover
        case author
        case original
        case duration
        case album
    }
}

struct CommerceInfo: Decodable {
    let advPromotable: Bool
    let auctionAdInvited: Bool
    let brandedContentType: Int
    let withCommentFilterWords: Bool

    enum CodingKeys: String, CodingKey {
        case advPromotable = "adv_promotable"
        case auctionAdInvited = "auction_ad_invited"
        case brandedContentType = "branded_content_type"
        case withCommentFilterWords = "with_comment_filter_words"
    }
}

struct Author: Decodable, Identifiable, Hashable {
    let id: String
    let uniqueId: String
    let nickname: String
    let avatar: URL

    enum CodingKeys: String, CodingKey {
        case id
        case uniqueId = "unique_id"
        case nickname
        case avatar
    }
}

extension Image {
    @ViewBuilder
    fileprivate func setRenderingMode(selected: Bool) -> some View {
        if selected {
            self.renderingMode(.template)
        } else {
            self.renderingMode(.original)
        }
    }
}



enum Tab: CaseIterable {
    case home
    case tags
    case history
    
    var tag: Int {
        switch self {
        case .home:
            return 0
        case .tags:
            return 1
        case .history:
            return 2
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "home"
        case .tags:
            return "tags"
        case .history:
            return "history"
        }
    }
    
    var unselectedIconName: String {
        switch self {
        case .home:
            return "home2"
        case .tags:
            return "tags2"
        case .history:
            return "history2"
        }
    }
}

    
struct MainView: View {
    
    @State private var selectedTab: Tab = .home
    let bannerHeight: CGFloat = 100

    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "#0E070D"))
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                DownView()
                    .tabItem {
                        Image(selectedTab == .home ? Tab.home.iconName : Tab.home.unselectedIconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    .tag(Tab.home)
                
                Hashtags()
                    .tabItem {
                        Image(selectedTab == .tags ? Tab.tags.iconName : Tab.tags.unselectedIconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    .tag(Tab.tags)
                
                History()
                    .tabItem {
                        Image(selectedTab == .history ? Tab.history.iconName : Tab.history.unselectedIconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    .tag(Tab.history)
            }
            .accentColor(Color(hex: "#F43BE1"))
            
            
        }
        .onAppear{
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if(!Client().GetDataPriv(key: Constants.USER_SUB_STATE).contains(Constants.SUB_STATE_OK)){
                    if(AppOpenAdManager.shared.isAdsReady){
                        AppOpenAdManager.shared.showAdIfAvailable()
                        AppOpenAdManager.shared.isAdsReady = false
                    }
                }
            }
        }
    }
}

struct DownView: View {
    @State private var searchText: String = ""
    @State private var isPopupVisible = false
    @State private var offset = UIScreen.main.bounds.height
    @State private var isShowPremium = false
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    @State private var showHistorySheet = false
    @State private var showBanner = false
    
    @State private var showLoader = false
    @State private var showPreview = false
    @State private var previewURL: URL?
    @State private var fetchError: String?

    var body: some View {
        ZStack {
            SideMenuContainerView(
                isMenuOpen: $presentSideMenu,
                content: {
                    mainContent
                },
                menu: {
                    SideMenuView(
                        selectedSideMenuTab: $selectedSideMenuTab,
                        presentSideMenu: $presentSideMenu,
                        showHistorySheet: $showHistorySheet  // ✅ buraya bağlandı
                    )
                    

                }
            )
            .sheet(isPresented: $showHistorySheet) {
                History()  // ya da HistoryView()
            }
            
            // MENÜ AÇIKKEN DIŞA TIKLAMAYI YAKALAYAN KATMAN
            if presentSideMenu {
                Color.black.opacity(0.001)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            presentSideMenu = false
                        }
                    }
            }

            // Loader
            if showLoader {
                Color.black.opacity(0.45).edgesIgnoringSafeArea(.all)
                ProgressView("Yükleniyor...".localizable)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
                    .padding(36)
                    .background(BlurView2(style: .systemMaterialDark))
                    .cornerRadius(18)
            }

            // Admob banner
            if showBanner {
                VStack {
                    Spacer()
                    BannerContentView(navigationTitle: "100")
                        .frame(height: 100)
                        .padding(.bottom, 5)
                }
            }
        }   
        .fullScreenCover(isPresented: $showPreview) {
            if let url = previewURL {
                VideoPreviewView(videoURL: url)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                if(Client().GetDataPriv(key: Constants.USER_SUB_STATE).contains(Constants.SUB_STATE_OK)){
                    if(showBanner){
                        showBanner = false
                    }
                }else{
                    showBanner = true
                }
            }
        }
    }

    var mainContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: { presentSideMenu.toggle() }) {
                    Image("ham")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                }
                .padding(.leading, 15)

                Spacer()

                Text("Video Downloader")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button(action: { isShowPremium.toggle() }) {
                    Image("pro")
                        .resizable()
                        .frame(width: 75, height: 44)
                        .cornerRadius(10)
                }
                .padding(.trailing, 15)
            }
            .fullScreenCover(isPresented: $isShowPremium) {
                Premium()
            }
            .padding(.top, 5)

            Text("Video Linki".localizable)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white)
                .padding(.top, 30)
                .padding(.leading, 40)

            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty) {
                    Text("www.tiktok.com/@user/video/...")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 13))
                }
                .padding()
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#2D2D2D"), lineWidth: 1)
                )
                .cornerRadius(16)
                .frame(height: 56)
                .padding(.horizontal, 20)
                .padding(.top, 10)

            Button(action: {
                if searchText.trimmingCharacters(in: .whitespaces).isEmpty { return }
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showLoader = true
                fetchError = nil

                TikTokDirectDownloader.fetchDirectVideoURL(from: searchText) { result in
                    DispatchQueue.main.async {
                        showLoader = false
                        switch result {
                        case .success(let url):
                            self.previewURL = url
                            self.showPreview = true
                            let newItem = VideoHistoryItem(
                                id: UUID(),
                                title: "New Video",
                                url: url.absoluteString,
                                duration: "",
                                coverImageData: UIImage(named: "logo")?.pngData(),
                                saltUrl: searchText
                            )
                            HistoryViewModel.shared.addItem(newItem)
                        case .failure(let error):
                            self.fetchError = error.localizedDescription
                        }
                    }
                }
            }) {
                Text("Bul".localizable)
                    .font(.system(size: 23, weight: .black))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [
                            Color(hex: "#F43BE1"),
                            Color(hex: "#FC1A94"),
                            Color(hex: "#F43B67"),
                            Color(hex: "#F43BE1")
                        ]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            VStack {
                HStack(spacing: 25) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 25, height: 25)
                        .overlay(
                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                        )
                    Text("Video veya resimler nasıl indirilir ?".localizable)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isPopupVisible = true
                    offset = 0
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.top, 20)

            if let error = fetchError {
                Text("Err: \(error)")
                    .foregroundColor(.red)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.top, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Spacer()

            // Popup
            ZStack {
                if isPopupVisible {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all).onTapGesture {
                        withAnimation {
                            isPopupVisible = false
                            offset = UIScreen.main.bounds.height
                        }
                    }
                    InfoView(isClosed: $isPopupVisible)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                        .background(Color(hex: "#0E070D"))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "#0E070D"), lineWidth: 1.2)
                        )
                        .offset(y: offset)
                        .padding(10)
                        .animation(.easeInOut(duration: 0.5), value: offset)
                }
            }
        }
        .contentShape(Rectangle()) // Tüm boş alanlara gesture algısı
        .onTapGesture {
            if presentSideMenu {
                withAnimation {
                    presentSideMenu = false
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}



struct VideoPreviewView: View {
    let videoURL: URL
    @State private var showShareSheet = false
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Custom init to create player before body runs
    init(videoURL: URL) {
        self.videoURL = videoURL
        _player = State(initialValue: AVPlayer(url: videoURL))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Video Player
                VideoPlayer(player: player)
                    .aspectRatio(9/16, contentMode: .fit)
                    .cornerRadius(16)
                    .frame(maxWidth: 330, maxHeight: 600)
                    .shadow(radius: 12)
                    .onAppear {
                        player.seek(to: .zero)
                        player.play()
                    }

                // Butonlar
                HStack(spacing: 30) {
                    Button(action: {
                        showShareSheet = true
                    }) {
                        Label("Paylaş".localizable, systemImage: "square.and.arrow.up")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 30)
                            .background(Color.blue)
                            .cornerRadius(14)
                    }

                    Button(action: {
                        downloadVideo(url: videoURL)
                    }) {
                        Label("İndir".localizable, systemImage: "arrow.down.circle.fill")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 30)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(14)
                    }
                }
                Spacer()
            }
            .padding(.top, 20)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showShareSheet) {
                ActivityView(activityItems: [videoURL])
            }
            .navigationBarTitle("Önizleme".localizable, displayMode: .inline)
            .toolbarBackground(Color(red: 16/255, green: 16/255, blue: 16/255), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .alert(isPresented: $showAlert) {
             Alert(title: Text("Durum"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
         }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !Client().GetDataPriv(key: Constants.USER_SUB_STATE).contains(Constants.SUB_STATE_OK) {
                    if let rootVC = UIApplication.shared.windows.first?.rootViewController,
                       let topVC = topViewController(rootVC) {
                        AdMobInterstitialManager.shared.showAd(from: topVC)
                    }
                }
            }
        }
    }
    
    func topViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        if let presented = rootViewController?.presentedViewController {
            return topViewController(presented)
        }
        if let nav = rootViewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = rootViewController as? UITabBarController {
            return topViewController(tab.selectedViewController)
        }
        return rootViewController
    }

    func downloadVideo(url: URL) {
        let session = URLSession.shared
        session.downloadTask(with: url) { tempURL, response, error in
            if let error = error {
                print("Download error:", error)
                return
            }
            guard let tempURL = tempURL else {
                print("Temp URL yok")
                return
            }

            let fileManager = FileManager.default
            let localURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mp4")

            do {
                try fileManager.copyItem(at: tempURL, to: localURL)
                print("Video başarıyla kopyalandı:", localURL.path)
            } catch {
                print("Kopyalama hatası:", error)
                return
            }

            // Fotoğraf izni iste
            PHPhotoLibrary.requestAuthorization { status in
                        if status == .authorized || status == .limited {
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: localURL)
                            }) { saved, error in
                                if let error = error {
                                    updateAlert("Kaydetme hatası: \(error.localizedDescription)")
                                } else if saved {
                                    updateAlert("🎉 Video başarıyla kaydedildi.")
                                } else {
                                    updateAlert("Video kaydedilemedi.")
                                }

                                try? fileManager.removeItem(at: localURL)
                            }
                        } else {
                            updateAlert("📛 Fotoğraf erişimi reddedildi.")
                        }
                    }
        }.resume()
    }

    func updateAlert(_ message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
            self.showAlert = true
        }
    }

}

// UIKit ile paylaşma için:
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Basit BlurView (isteğe bağlı)
struct BlurView2: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct InfoView: View {
    @State private var currentIndex: Int = 0
    private let images = ["slide1", "slide2", "slide3"]
    private let infos = [
        NSLocalizedString("step_1_info", comment: ""),
        NSLocalizedString("step_2_info", comment: ""),
        NSLocalizedString("step_3_info", comment: "")
    ]
    @Binding var isClosed: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(hex: "#0E070D").edgesIgnoringSafeArea(.all)
            Button(action: {
                withAnimation {
                    isClosed.toggle()
                }
                print("Close button tapped")
            }) {
                Image("closebtn") // "closebtn" görselini kullanıyoruz
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45) // Buton boyutları
            }
            .padding(.top, 10)
            .padding(.leading, 10)
            
            // 1. Adım metni
            Text("\(currentIndex + 1). Adım")
                .font(.system(size: 15,weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 25) // Üstten 10px boşluk
                .padding(.leading, 30) // Soldan 30px boşluk
                .padding(.trailing, 30) // Sağdan 30px boşluk
            
            Text("\(infos[currentIndex])")
                .font(.system(size: 13,weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center) // Ortalanmış text
                .padding(.top, 60) // Üstten 10px boşluk
                .padding(.leading, 20) // Soldan 30px boşluk
                .padding(.trailing, 20) // Sağdan 30px boşluk
            
            // Resim slider'ı
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(images[index]) // Resimleri slider'a yerleştiriyoruz
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .tag(index) // Her resme benzersiz bir tag atıyoruz
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 200)
                .padding(.horizontal, 30)
                .padding(.top,10)
            }
            .padding(.top, 80)

        }
        .background(Color(hex: "#0E070D"))
        .frame(height: 300)
    }
}


// Placeholder için extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// Hex renk desteği için extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    MainView()
}
