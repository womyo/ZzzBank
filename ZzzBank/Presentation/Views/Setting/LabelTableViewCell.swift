//
//  ManualRepaymentTableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 3/25/25.
//

import UIKit
import Then

class LabelTableViewCell: UITableViewCell {
    static let identifier = "LabelTableViewCell"
    
    private let label = UILabel()
    
    var onButtonTapped: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        backgroundColor = .customBackgroundColor
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with text: String) {
        label.text = text
    }
}
