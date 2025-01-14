//
//  NotificationManager.swift
//  ZzzBank
//
//  Created by 이인호 on 1/15/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
    
    private init() {}
    
    func scheduleNotification(id: String, endDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "잠은행"
        content.body = "대출 마감 당일입니다!"
        content.sound = .default
        
        content.userInfo = ["body": content.body]
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: endDate)
        dateComponents.hour = 14
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification-\(id)", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error in scheduling notification \(error.localizedDescription)")
            }
        }
    }
    
    func removeNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
