//
//  InstagramDirectDownloader.swift
//  VideoDownloader
//
//  Created by mac on 10/3/25.
//

import Foundation

class InstagramDirectDownloader {
    static func fetchDirectVideoURL(from igURL: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let base = "https://instagram-reels-downloader-api.p.rapidapi.com/download?url="
        
        guard let urlEncoded = igURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let apiURL = URL(string: "\(base)\(urlEncoded)") else {
            completion(.failure(NSError(domain: "Invalid Instagram URL", code: -1)))
            return
        }
        
        var req = URLRequest(url: apiURL)
        req.setValue("instagram-reels-downloader-api.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        req.setValue("705a97f725msh399c3980ae0a32ep125b25jsn1ff6ce5c6330c", forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataDict = json["data"] as? [String: Any],
                  let medias = dataDict["medias"] as? [[String: Any]] else {
                completion(.failure(NSError(domain: "Invalid JSON", code: -3)))
                return
            }
            
            print("Instagram API Response:", dataDict) // 🔍 debug
            
            if let video = medias.first(where: { ($0["type"] as? String) == "video" }),
               let urlString = video["url"] as? String,
               let url = URL(string: urlString) {
                completion(.success(url))
                return
            }
            
            completion(.failure(NSError(domain: "Instagram: Direkt video link bulunamadı", code: -2)))
        }.resume()
    }
}


//InstagramDirectDownloader.fetchDirectVideoURL(
//    from: "https://www.instagram.com/reel/DJg8Hc_zkot/?igsh=MXFvaDhueHozZjQ2bQ=="
//) { result in
//    switch result {
//    case .success(let directURL):
//        print("Video indirilebilir link:", directURL)
//    case .failure(let error):
//        print("Hata:", error.localizedDescription)
//    }
//}
