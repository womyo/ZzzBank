import Foundation
import SwiftUI

class KeyboardInfo: ObservableObject {
    @MainActor static let shared = KeyboardInfo()
    
    @Published public var isKeyboardShow = false
    @Published var animationDuration: Double = 0
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    func removeObservers() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    
    @objc func keyboardUp(notification: Notification) {
        isKeyboardShow = true
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        animationDuration = duration
    }
    
    @objc func keyboardDown(notification: Notification) {
        isKeyboardShow = false
    }
}
