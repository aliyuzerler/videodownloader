//
//  SideMenu.swift
//  VideoDownloader
//
//  Created by mac on 12/17/24.
//

import SwiftUI


enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case favorite
    case chat
    case profile
    
    var title: String{
        switch self {
        case .home:
            return "Home".localizable
        case .favorite:
            return "History".localizable
        case .chat:
            return "Give 5 stars".localizable
        case .profile:
            return "Privacy Policy".localizable
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "home"
        case .favorite:
            return "history2"
        case .chat:
            return "heart"
        case .profile:
            return "priv"
        }
    }
}

struct SideMenuContainer<Content: View>: View {
    @State private var isMenuVisible = false
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            SideMenu(isShowing: $isMenuVisible)

            content
                .scaleEffect(isMenuVisible ? 0.88 : 1.0)
                .rotation3DEffect(
                    .degrees(isMenuVisible ? -10 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .offset(x: isMenuVisible ? 265 : 0)
                .disabled(isMenuVisible)
                .overlay(
                    isMenuVisible ?
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    isMenuVisible = false
                                }
                            }
                        : nil
                )
                .animation(.easeInOut(duration: 0.25), value: isMenuVisible)

            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            isMenuVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct SideMenu: View {
    @Binding var isShowing: Bool
    @State private var showHistorySheet = false

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.7), radius: 8, x: 0, y: 4)

                Text("Video Downloader")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.top, 40)

            Spacer()

            VStack(spacing: 24) {
                ForEach(SideMenuRowType.allCases, id: \.self) { row in
                    HStack(spacing: 16) {
                        Image(row.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)

                        Text(row.title)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(10)
                    .onTapGesture {
                        handleTap(for: row)
                    }
                }
            }
            .padding(.bottom, 40)

            Spacer()
        }
        .frame(maxWidth: 270)
        .background(Color(hex: "#101010"))
        .ignoresSafeArea()
        .sheet(isPresented: $showHistorySheet) {
            History()
        }
    }

    private func handleTap(for row: SideMenuRowType) {
        switch row {
        case .favorite:
            isShowing = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                showHistorySheet = true
            }

        case .chat:
            if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }

        case .profile:
            if let url = URL(string: "https://hardcodedevs.com/privacy_downloader.html"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }

        default:
            isShowing = false
        }
    }
}


extension AnyTransition {
    static var slideInFromLeftAndOutToRight: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .leading),  // soldan içeri
            removal: .move(edge: .trailing)   // sağdan dışarı
        )
    }
}

