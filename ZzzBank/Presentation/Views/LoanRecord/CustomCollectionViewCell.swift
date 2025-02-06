//
//  CustomCollectionViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 1/23/25.
//

import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {        
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func configure(with text: String) {
        label.text = text
    }
}
