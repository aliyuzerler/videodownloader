//
//  SideMenuContainerView.swift
//  VideoDownloader
//
//  Created by mac on 7/16/25.
//


import SwiftUI

struct SideMenuContainerView<Content: View, Menu: View>: View {
    @Binding var isMenuOpen: Bool
    let content: () -> Content
    let menu: () -> Menu

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                // Bu görünmeyen layer menü açıksa dokunma algılar
                if isMenuOpen {
                    Color.black.opacity(0.001) // görünmez ama tıklanabilir
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isMenuOpen = false
                            }
                        }
                        .zIndex(0)
                }

                content()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(isMenuOpen ? 0.88 : 1.0)
                    .rotation3DEffect(
                        .degrees(isMenuOpen ? -12 : 0),
                        axis: (x: 0, y: 1, z: 0),
                        anchor: .leading,
                        anchorZ: 0,
                        perspective: 0.7
                    )
                    .offset(x: isMenuOpen ? geometry.size.width * 0.55 : 0)
                    .shadow(color: .black.opacity(isMenuOpen ? 0.3 : 0), radius: 10)
                    .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
                    .disabled(isMenuOpen)
                    .zIndex(1)

                if isMenuOpen {
                    menu()
                        .frame(width: geometry.size.width * 0.6)
                        .transition(.move(edge: .leading))
                        .zIndex(2)
                }
            }
        }
    }
}
    