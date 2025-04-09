//
//  AppDelegate.swift
//  ZzzBank
//
//  Created by 이인호 on 1/6/25.
//

import UIKit
import BackgroundTasks
import Firebase
import FirebaseCore
import FirebaseFirestore
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let viewModel = LoanViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        HealthKitManager.shared.configure()
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.value(forKey: "appFirstOpen") == nil {
            userDefaults.setValue(true, forKey: "appFirstOpen")
            userDefaults.setValue(7, forKey: "personSleep")
            let loanLimit = LoanLimit()
            RealmManager.shared.write(loanLimit)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        print(RealmManager.shared.getLocationOfDefaultRealm())
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        HealthKitManager.shared.getSleepData() { result in
            let amount = result - UserDefaults.standard.integer(forKey: "personSleep")
            if amount > 0 {
                self.viewModel.payLoad(amount: amount)
            }
            
            self.viewModel.getLoanRecords().enumerated().forEach { index, loanRecord in
                if Date() > loanRecord.repaymentDate {
                    let overdueDays = Calendar.current.dateComponents([.day], from: loanRecord.repaymentDate, to: Date()).day ?? 0
                    self.viewModel.updateLoanRecords(index: index, overdueDays: overdueDays)
                }
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }

        let userId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let documentRef = Firestore.firestore().collection("Device").document(userId)
        let timeZone = TimeZone.current.identifier

        let data: [String: Any] = [
            "tokenId": token,
            "timeZone": timeZone,
            "updatedAt": FieldValue.serverTimestamp()
        ]

        documentRef.setData(data, merge: true)
    }
}
