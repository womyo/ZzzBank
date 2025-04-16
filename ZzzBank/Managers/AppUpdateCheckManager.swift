//
//  AppUpdateCheckManager.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/16/25.
//

import UIKit

final class AppUpdateCheckManager {
    static let shared = AppUpdateCheckManager()
    private let appleID = Bundle.main.infoDictionary?["APPLE_ID"] as? String ?? ""
    
    private init() {}
    
    func latestVersion() async -> String? {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleID)") else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let results = json?["results"] as? [[String: Any]]
            return results?.first?["version"] as? String
        } catch {
            return nil
        }
    }
    
    func openAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/apple-store/\(appleID)"
        
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
