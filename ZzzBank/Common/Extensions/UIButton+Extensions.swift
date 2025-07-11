import UIKit

extension UIButton {
    func animatePress(scale: CGFloat = 0.98, duration: TimeInterval = 0.1, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            }) { _ in
                completion?()
            }
        }
    }
}
