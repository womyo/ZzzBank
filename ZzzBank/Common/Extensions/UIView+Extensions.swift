//
//  UIView+Extension.swift
//  ZzzBank
//
//  Created by 이인호 on 1/19/25.
//

import UIKit

extension UIView {
    func setViewShadow(backView: UIView) {
        layer.masksToBounds = true
        layer.cornerRadius = 20
        
        backView.layer.masksToBounds = false
        backView.layer.shadowOpacity = 0.7
        backView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backView.layer.shadowRadius = 5
        backView.layer.shadowColor = UIColor.shadowColor.cgColor
    }
    
    func addSubviews(_ views : UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
