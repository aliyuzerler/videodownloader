//
//  Hashtags.swift
//  VideoDownloader
//
//  Created by mac on 12/17/24.
//

import SwiftUI
import AlertToast

struct Hashtags: View {
    @State private var tags: [String] = [
        "#tbt", "#istanbul", "#love", "#fashion", "#turkey", "#likeforlike", "#photooftheday", "#ankara", "#instagood", "#art", "#izmir", "#style", "#antalya", "#travel", "#summer", "#photography", "#selfie", "#aşk", "#mutluluk", "#gezi", "#food", "#tatil", "#çocuk", "#hediye", "#günaydın", "#güzel", "#moda", "#doğa", "#kahve", "#manzara", "#music", "#sunset", "#gezgin", "#fitness", "#spor", "#sağlık", "#yoga", "#film", "#şarkı", "#shopping", "#keşfet", "#kombin", "#like4like", "#mood", "#trend", "#instagram", "#mutfak", "#travelgram", "#evdekorasyonu", "#hayat"
     ]
     @State private var selectedTags: [String] = []
     @Namespace private var animation
    @State private var showToast = false
    
    
    var body: some View {
         VStack(spacing: 0) {
             ScrollView(.horizontal) {
                 HStack(spacing: 12) {
                     ForEach(selectedTags, id: \.self) { tag in
                         TagView(tag: tag, isSelected: true)
                             .matchedGeometryEffect(id: tag, in: animation)
                             .onTapGesture {
                                 withAnimation(.spring()) {
                                     selectedTags.removeAll(where: { $0 == tag })
                                 }
                             }
                     }
                 }
                 .padding(.horizontal, 15)
                 .frame(height: 35)
                 .padding(.vertical, 15)
             }
             //.scrollDisabled(true)
             //.scrollIndicators(.hidden)
             .overlay(alignment: .center) {
                 if selectedTags.isEmpty {
                     Text("En popüler 50 #hashtag".localizable)
                         .font(.title2)
                         .foregroundColor(.white)
                 }
             }
        .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#F43BE1"),
                        Color(hex: "#FC1A94"),
                        Color(hex: "#F43B67"),
                        Color(hex: "#F43BE1")
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
             .zIndex(1)
             
             ScrollView(.vertical) {
                     TagLayout(alignment: .center, spacing: 10) {
                         ForEach(tags.filter { !selectedTags.contains($0) }, id: \.self) { tag in
                             TagView(tag: tag, isSelected: false)
                                 .matchedGeometryEffect(id: tag, in: animation)
                                 .onTapGesture {
                                     withAnimation(.spring()) {
                                         selectedTags.insert(tag, at: 0)
                                     }
                                 }
                         }
                     }
                     .padding(15)
             }
            // .scrollDisabled(true)
            // .scrollIndicators(.hidden)
             .background(Color.black.opacity(0.05))
             .zIndex(0)
             
             ZStack {
                 Button(action: {
                     let tagsString = selectedTags.joined(separator: ",")
                     print(tagsString)
                     showToast.toggle()
                 }) {
                     
                     
                     Text("Kopyala".localizable)
                         .fontWeight(.semibold)
                         .padding(.vertical, 15)
                         .frame(maxWidth: .infinity)
                         .foregroundColor(.white)
                         .background(
                             LinearGradient(
                                 gradient: Gradient(colors: [
                                     Color(hex: "#F43BE1"),
                                     Color(hex: "#FC1A94"),
                                     Color(hex: "#F43B67"),
                                     Color(hex: "#F43BE1")
                                 ]),
                                 startPoint: .leading,
                                 endPoint: .trailing
                             )
                         )
                         .cornerRadius(12)
                 }
                 .padding()
             }
             .toast(isPresenting: $showToast){
                 AlertToast(displayMode: .banner(.slide), type: .regular, title: "Link kopyalandı!".localizable)
             }
             .background(Color("black"))
             .zIndex(2)
         }

     }
     
     @ViewBuilder
     func TagView(tag: String, isSelected: Bool) -> some View {
         HStack(spacing: 10) {
             Text(tag)
                 .font(.callout)
                 .fontWeight(.semibold)
             
             Image(systemName: isSelected ? "checkmark" : "plus")
         }
         .frame(height: 35)
         .foregroundColor(isSelected ? .white : .white)
         .padding(.horizontal, 15)
         .background(Capsule().fill(isSelected ? Color.black : Color("black")))
     }
 }


 struct TagLayout: Layout {
     var alignment: Alignment = .center
     var spacing: CGFloat = 10

     func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
         let maxWidth = proposal.width ?? 0
         var height: CGFloat = 0
         let rows = generateRows(maxWidth, proposal, subviews)
         
         for (index, row) in rows.enumerated() {
             if index == (rows.count - 1) {
                 height += row.maxHeight(proposal)
             } else {
                 height += row.maxHeight(proposal) + spacing
             }
         }
         
         return CGSize(width: maxWidth, height: height)
     }
     
     func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
         var origin = bounds.origin
         let maxWidth = bounds.width
         
         let rows = generateRows(maxWidth, proposal, subviews)
         
         for row in rows {
             let leading: CGFloat = bounds.maxX - maxWidth
             let trailing = bounds.maxX - row.reduce(CGFloat.zero) { partialResult, view in
                 let width = view.sizeThatFits(proposal).width
                 return partialResult + width + (view == row.last ? 0 : spacing)
             }
             let center = (trailing + leading) / 2
             
             origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : center)
             
             for view in row {
                 let viewSize = view.sizeThatFits(proposal)
                 view.place(at: origin, proposal: proposal)
                 origin.x += (viewSize.width + spacing)
             }
             
             origin.y += (row.maxHeight(proposal) + spacing)
         }
     }
     
     func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews) -> [[LayoutSubviews.Element]] {
         var row: [LayoutSubviews.Element] = []
         var rows: [[LayoutSubviews.Element]] = []
         var origin = CGPoint.zero
         
         for view in subviews {
             let viewSize = view.sizeThatFits(proposal)
             
             if (origin.x + viewSize.width + spacing) > maxWidth {
                 rows.append(row)
                 row.removeAll()
                 origin.x = 0
             }
             
             row.append(view)
             origin.x += (viewSize.width + spacing)
         }
         
         if !row.isEmpty {
             rows.append(row)
         }
         
         return rows
     }
 }

extension Array where Element == LayoutSubviews.Element {
     func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
         self.compactMap { view in
             view.sizeThatFits(proposal).height
         }.max() ?? 0
     }
 }

#Preview {
    Hashtags()
}
