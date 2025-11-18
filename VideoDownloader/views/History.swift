import SwiftUI
import MijickPopups


struct History: View {
    @StateObject private var vm = HistoryViewModel.shared
    @State private var showPreview = false
    @State private var selectedURL: URL?
    @State private var showCopyAlert = false
    @State private var showDeleteAllPopup = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                contentView

                if !vm.items.isEmpty {
                    deleteAllButton
                }
            }
            .navigationTitle("History".localizable)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black.ignoresSafeArea())
            .toolbarBackground(Color(hex: "#101010"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .fullScreenCover(isPresented: $showPreview) {
                if let url = selectedURL {
                    VideoPreviewView(videoURL: url)
                } else {
                    Text("URL yok")
                        .foregroundColor(.white)
                        .background(Color.black.ignoresSafeArea())
                }
            }
            .alert("Link kopyalandı!".localizable, isPresented: $showCopyAlert) {
                Button("Tamam".localizable, role: .cancel) { }
            }
//            .popup(isPresented: $showDeleteAllPopup, type: .toast, position: .bottom, animation: .spring(), closeOnTap: false, backgroundColor: Color.black.opacity(0.2)) {
//                DeleteAllPopupView(
//                    onCancel: { showDeleteAllPopup = false },
//                    onDelete: {
//                        vm.items.removeAll()
//                        vm.save()
//                        showDeleteAllPopup = false
//                    }
//                )
//            }
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    private var contentView: some View {
        if vm.items.isEmpty {
            EmptyHistoryView()
        } else {
            List {
                ForEach(vm.items) { item in
                    HistoryRow(
                        item: item,
                        onCopy: {
                            UIPasteboard.general.string = item.saltUrl
                            showCopyAlert = true
                        }
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Video açmak istersen buraya kodunu yaz
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                }
                .onDelete { indexSet in
                    vm.items.remove(atOffsets: indexSet)
                    vm.save()
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .listStyle(.plain)
        }
    }

    private var deleteAllButton: some View {
        VStack {
            Button(action: {
                //showDeleteAllPopup = true
                Task{
                    await DeleteAllPopupView(
                        onCancel: { /* iptal */ },
                        onDelete: {
                            Task{
                                vm.clear()
                                await PopupStack.dismissAllPopups()
                            }
                        }
                    ).present()
                }
            }) {
                Text("Tüm Geçmişi Sil".localizable)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.red)
                    .cornerRadius(14)
                    .padding(.horizontal, 28)
                    .shadow(color: Color.black.opacity(0.14), radius: 5, x: 0, y: 2)
            }
            .padding(.bottom, 20)
        }
        .transition(.move(edge: .bottom))
        .animation(.easeInOut(duration: 0.18), value: vm.items.count)
    }
}

// MARK: - Custom Views

struct DeleteAllPopupView: BottomPopup {
    let onCancel: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Pull indicator
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            // Lottie animation (150x150)
            LottieView(name: "delete_warning", loopMode: .loop)
                .frame(width: 150, height: 150)

            // Message
            Text("Tüm geçmişi silmek istediğine emin misin?".localizable)
                .multilineTextAlignment(.center)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal)

            // Action buttons
            HStack(spacing: 18) {
                Button(action: {
                    Task {
                         onCancel()
                        await PopupStack.dismissAllPopups()
                     }
                }) {
                    Text("Vazgeç".localizable)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                }


                Button(action: onDelete) {
                    Text("Sil".localizable)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)

            Spacer().frame(height: 20)
        }
        .padding(.horizontal, 24)
        .background(
            Color(hex: "#1C1C1C")
        )
       // .cornerRadius(22)
        .shadow(radius: 16)
    }

    func configurePopup(config: BottomPopupConfig) -> BottomPopupConfig {
        config
            .cornerRadius(0)
            .backgroundColor(Color(hex: "#1C1C1C"))
            .popupHorizontalPadding(0)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


struct EmptyHistoryView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("No history found".localizable).foregroundColor(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct HistoryRow: View {
    let item: VideoHistoryItem
    let onCopy: () -> Void

    var body: some View {
        HStack(spacing: 15) {
            HistoryRowImage(data: item.coverImageData)
            HistoryRowInfo(title: item.title, url: item.saltUrl, duration: item.duration)
            Spacer()
            CopyLinkButton(onCopy: onCopy)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 0).fill(Color(hex: "#151515")))
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct HistoryRowImage: View {
    let data: Data?

    var body: some View {
        Group {
            if let data = data, let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 56, height: 56)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 56, height: 56)
                    .cornerRadius(10)
            }
        }
    }
}

struct HistoryRowInfo: View {
    let title: String
    let url: String
    let duration: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .lineLimit(1)
            Text(url)
                .foregroundColor(.gray)
                .font(.system(size: 13))
                .lineLimit(1)
            Text(duration)
                .foregroundColor(.gray)
                .font(.system(size: 13))
        }
    }
}

struct CopyLinkButton: View {
    let onCopy: () -> Void

    var body: some View {
        Button(action: onCopy) {
            Text("Link Kopyala".localizable)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(Color.red)
                .cornerRadius(7)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    History()
}
