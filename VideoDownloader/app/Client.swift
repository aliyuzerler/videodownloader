//
//  Client.swift
//  VideoDownloader
//
//  Created by mac on 12/17/24.
//


import Foundation
import UserNotifications
import UIKit

class Client{
    
    enum DeviceType {
        case iPhone
        case iPad
    }

    func GetDataPriv(key: String) -> String{
        
        return UserDefaults.standard.string(forKey: key) ?? "null"
    }
    
    func SaveDataPriv(key: String,value: String)
    {
        
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func getAllKeysWithPrefix(_ prefix: String) -> [String]
    {
        return UserDefaults.standard.dictionaryRepresentation().keys.filter { $0.starts(with: prefix) }
    }
    
    func getDataPriv(key: String) -> String?
    {
         return UserDefaults.standard.string(forKey: key)
    }
    
    func tapHabbit(){
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
    }
    
    func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("İzin verildi.")
            } else if let error = error {
                print("Bildirim izni reddedildi: \(error.localizedDescription)")
            } else {
                print("Bildirim izni reddedildi.")
            }
        }
    }

    func checkTimeStamp() -> Bool {
        guard let savedDate = UserDefaults.standard.object(forKey: "lastTimeStamp") as? Date else {
            return false
        }

        let currentDate = Date()
        let differenceInMinutes = currentDate.timeIntervalSince(savedDate) / 60

        return differenceInMinutes >= 5
    }


    func createNotification(in seconds: TimeInterval, message: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { [self] settings in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = "Statix"
                content.body = message
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("fail: \(error.localizedDescription)")
                    } else {
                        print("success")
                    }
                }
            } else {
                print("no permission")
                requestNotificationPermission()
            }
        }
    }
    
    func medium(size: CGFloat) -> UIFont
      {
          return UIFont(name: "Poppins-Medium", size: size)!
          
      }
      
      func thin(size: CGFloat) -> UIFont
      {
          return UIFont(name: "Poppins-Thin", size: size)!
          
      }
      
      
      func bold(size: CGFloat) -> UIFont
      {
          return UIFont(name: "Poppins-Bold", size: size)!
          
      }
      
      func semibold(size: CGFloat) -> UIFont
      {
          return UIFont(name: "Poppins-SemiBold", size: size)!
          
      }
      
      
      func light(size: CGFloat) -> UIFont
      {
          return UIFont(name: "Poppins-Light", size: size)!
          
      }
      
      func black(size: CGFloat) -> UIFont
      {
          return UIFont(name: "Poppins-Black", size: size)!
          
      }
      
      func extrabold(size: CGFloat) -> UIFont
      {
          return UIFont(name: "Poppins-ExtraBold", size: size)!
          
      }
      
      func regular(size: CGFloat) -> UIFont
      {
          return UIFont(name: "Poppins-Regular", size: size)!
          
      }
    
    
    
    func initAnimationName() -> (String, String, String) {
        if Client().getDataPriv(key: Constants.IS_ONLINE)!.contains("1") {
            return ("onboard1", "onboard2", "onboard3")
        } else {
            return ("onboard1", "onboard2", "onboard3")
        }
    }
    
    
    func getGenderFromAPI(name: String, completion: @escaping (String) -> Void) {
        let urlString = "https://api.genderize.io?name=\(name)"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let gender = jsonResponse["gender"] as? String {
                            completion(gender)
                        } else {
                            completion("Bilinmiyor")
                        }
                    } catch {
                        completion("Bilinmiyor")
                    }
                } else {
                    completion("Bilinmiyor")
                }
            }
            task.resume()
        } else {
            completion("Bilinmiyor")
        }
    }
    
    

    
    func getDeviceType() -> DeviceType {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .iPhone
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        } else {
            return .iPhone // Varsayılan olarak iPhone
        }
    }
    
    
    
}
