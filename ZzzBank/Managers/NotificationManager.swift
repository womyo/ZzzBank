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
        content.title = "ZzzBank"
        content.body = "Your loan is due today!"
        content.sound = .default
        content.badge = 1
        
        content.userInfo = ["body": content.body]
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: endDate)
        dateComponents.hour = 10
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification-\(id)", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error in scheduling notification \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "ZzzBank"
        content.body = "Sleep data is updated. Check now."
        
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "DailyNotification", content: content, trigger: trigger)
        
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
