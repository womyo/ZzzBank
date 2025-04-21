//
//  AlertTableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 3/25/25.
//

import UIKit
import Then

class AlertTableViewCell: UITableViewCell {
    static let identifier = "AlertTableViewCell"
    
    private let titleLabel = UILabel().then {
        $0.text = "Alert"
    }
    
    private let toggleSwitch = UISwitch().then { toggle in
        toggle.onTintColor = .mainColor
        
        toggle.isOn = UserDefaults.standard.bool(forKey: "isAlert")
        toggle.addAction(UIAction { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            UserDefaults.standard.set(toggle.isOn, forKey: "isAlert")
        }, for: .valueChanged)
    }
    
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
        
        contentView.addSubviews(titleLabel, toggleSwitch)
        
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
