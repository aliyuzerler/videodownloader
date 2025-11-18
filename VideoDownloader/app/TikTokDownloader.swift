import Foundation

class TikTokDirectDownloader {
    static func fetchDirectVideoURL(from tiktokURL: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let base = "https://tikwm.com/api/"
        guard let urlEncoded = tiktokURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let apiURL = URL(string: "\(base)?url=\(urlEncoded)") else {
            completion(.failure(NSError(domain: "Invalid TikTok URL", code: -1)))
            return
        }
        var req = URLRequest(url: apiURL)
        req.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X)", forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataDict = json["data"] as? [String: Any],
                  let urlString = dataDict["play"] as? String,
                  let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "TikWM: Direkt video link bulunamadı", code: -2)))
                return
            }
            completion(.success(url))
        }.resume()
    }
}
