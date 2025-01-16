//
//  BorrowedView.swift
//  ZzzBank
//
//  Created by 이인호 on 1/16/25.
//

import UIKit
import SnapKit

class BorrowedView: UIView {
    private let borrowedLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let borrowedValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.borderWidth = 0.8
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [borrowedLabel, borrowedValue])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    func setBorrowedValue<T> (_ text: String, _ value: T) {
        self.borrowedLabel.text = text
        self.borrowedValue.text = "\(value) hours"
    }
}
