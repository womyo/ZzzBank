//
//  AlertTableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 3/25/25.
//

import UIKit

class AlertTableViewCell: UITableViewCell {
    static let identifier = "AlertTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Alert"
        
        return label
    }()
    
    private let toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.onTintColor = .mainColor
        
        toggleSwitch.isOn = UserDefaults.standard.bool(forKey: "isAlert")
        toggleSwitch.addAction(UIAction { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            UserDefaults.standard.set(toggleSwitch.isOn, forKey: "isAlert")
        }, for: .valueChanged)
        
        return toggleSwitch
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
        backgroundColor = .customBackgroundColor
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        toggleSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
}
