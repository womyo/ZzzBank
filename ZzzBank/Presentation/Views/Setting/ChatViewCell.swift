//
//  ChatViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 7/7/25.
//

import UIKit

class ChatViewCell: UITableViewCell {
    static let identifier = "ChatViewCell"
    
    private let chatLabel: UILabel = {
        let label = UILabel()
        label.text = "Midnight Chat"
        
        return label
    }()
    
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
        
        contentView.addSubview(chatLabel)
        
        chatLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
