//
//  ManualRepaymentTableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 3/25/25.
//

import UIKit

class ManualRepaymentTableViewCell: UITableViewCell {
    static let identifier = "ManualRepaymentTableViewCell"
    
    private let repaymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Sleep Repay (Manual)"
        
        return label
    }()
    
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
        
        contentView.addSubview(repaymentLabel)
        
        repaymentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
