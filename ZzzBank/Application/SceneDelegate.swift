//
//  SceneDelegate.swift
//  ZzzBank
//
//  Created by 이인호 on 1/6/25.
//

import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let viewModel = LoanViewModel()
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UNUserNotificationCenter.current().delegate = self
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(didFinishOnboarding), name: .didFinishOnboarding, object: nil
        )
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        showLaunchScreen()
        
        if UserDefaults.standard.value(forKey: "didFinishOnboarding") == nil {
            showOnboardingScreen()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showMainScreen()
            }
        }
    }
    
    private func showOnboardingScreen() {
        let onboardingVC = OnboardingPageViewController()
        window?.rootViewController = onboardingVC
        window?.makeKeyAndVisible()
    }
    
    private func showLaunchScreen() {
        // Launch Screen을 불러와서 표시
        let launchStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchScreenVC = launchStoryboard.instantiateInitialViewController()
        window?.rootViewController = launchScreenVC
        window?.makeKeyAndVisible()
    }
    
    private func showMainScreen() {
        // 메인 화면으로 전환
        DispatchQueue.main.async {
            self.window?.rootViewController = UINavigationController(rootViewController: TabBarController())
            self.window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    @objc func didFinishOnboarding() {
        UserDefaults.standard.set(true, forKey: "didFinishOnboarding")
        
        let viewController = TabBarController()
        viewController.view.alpha = 0
        
        UIView.transition(with: self.window!, duration: 0.4, options: [.transitionCrossDissolve], animations: {
            self.window?.rootViewController = UINavigationController(rootViewController: viewController)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                viewController.view.alpha = 1
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.requestNotificationAuthorization()
                }
            }
        }
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    NotificationManager.shared.scheduleDailyNotification()
                }
                
                UserDefaults.standard.set(true, forKey: "isAlert")
                print("Notification authorization granted.")
            } else {
                UserDefaults.standard.set(false, forKey: "isAlert")
                print("Notification authorization denied.")
            }
            HealthKitManager.shared.configure()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "DailyNotification" {
            HealthKitManager.shared.getSleepData() { result in
                DispatchQueue.main.async {
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
        }
        
        completionHandler()
    }
}
