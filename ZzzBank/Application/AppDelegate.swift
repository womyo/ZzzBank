//
//  AppDelegate.swift
//  ZzzBank
//
//  Created by 이인호 on 1/6/25.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        HealthKitManager.shared.configure()
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.value(forKey: "appFirstOpen") == nil {
            userDefaults.setValue(true, forKey: "appFirstOpen")
            
            let loanLimit = LoanLimit()
            loanLimit.limitTime = 24
            RealmManager.shared.write(loanLimit)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.updateLoanRecords", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGAppRefreshTask)
        }
        
//        print(RealmManager.shared.getLocationOfDefaultRealm())
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
    
    func handleBackgroundTask(task: BGAppRefreshTask) {
        let viewModel = LoanViewModel()
        let calendar = Calendar.current
        
        viewModel.getLoanRecords().enumerated().forEach { index, loanRecord in
            let dateComponents = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: loanRecord.date))
            
            if let days = dateComponents.day, Date() > loanRecord.date {
                viewModel.updateLoanRecords(index: index, overdueDays: abs(days))
            }
        }
        scheduleBackgroundTask()
        task.setTaskCompleted(success: true)
    }
    
    func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.updateLoanRecords")
        request.earliestBeginDate = Calendar.current.startOfDay(for: Date()).addingTimeInterval(24*60*60)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Unable to schedule background task: \(error.localizedDescription)")
        }
    }
}

