import SwiftUI


struct SideMenuView: View {
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @Binding var showHistorySheet: Bool
    
    var body: some View {
        HStack {
            ZStack {
                ProfileImageView()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .aspectRatio(contentMode: .fit)
            }
            .background(.black)
            .frame(width: 270, height: 300)
        }
        .background(.black)
    }

    
    func onRowTap(row: SideMenuRowType) {
        withAnimation {
            presentSideMenu = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            switch row {
            case .home:
                break
            case .favorite:
                showHistorySheet = true  // ✅ Sheet burada tetiklenecek
            case .chat:
                print("ahooo")
            case .profile:
                if let url = URL(string: "https://yourwebsite.com/profile") {
                    UIApplication.shared.open(url)
                }
            }
        }
        
        selectedSideMenuTab = row.rawValue
    }
}


func ProfileImageView() -> some View {
    VStack(alignment: .center) {
        HStack {
            Spacer()
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(20)
            Spacer()
        }
        Text("Video Downloader")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
        Text("Version 1.0.3")
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.gray)
    }
}

func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                Rectangle()
                    .fill(isSelected ? .purple : .purple)
                    .frame(width: 5)
                
                Image(imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(isSelected ? .purple : .gray)
                    .frame(width: 26, height: 26)
                    .frame(width: 30, height: 30)
                
                Text(title)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(isSelected ? .white : .gray)
                Spacer()
            }
        }
    }
    .frame(height: 50)
    .background(
        LinearGradient(
            colors: [isSelected ? .purple.opacity(0.5) : Color(hex: "0E070D"), Color(hex: "0E070D")],
            startPoint: .leading,
            endPoint: .trailing
        )
    )
}
