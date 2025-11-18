//
//  VideoHistoryItem.swift
//  VideoDownloader
//
//  Created by mac on 7/16/25.
//

import SwiftUI


struct VideoHistoryItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let url: String
    let duration: String
    let coverImageData: Data?
    let saltUrl: String
}

class HistoryViewModel: ObservableObject {
    static let shared = HistoryViewModel()
    @Published var items: [VideoHistoryItem] = []
    private init() { load() }

    func load() {
        // Hafızadan (UserDefaults) yükle
        if let data = UserDefaults.standard.data(forKey: "videoHistory"),
           let decoded = try? JSONDecoder().decode([VideoHistoryItem].self, from: data) {
            self.items = decoded
        }
    }
    
    func addItem(_ item: VideoHistoryItem) {
        items.insert(item, at: 0)
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "videoHistory")
        }
    }
    
    func clear() {
        items = []
        UserDefaults.standard.removeObject(forKey: "videoHistory")
    }
}


