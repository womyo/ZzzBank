//
//  StepperTableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 3/27/25.
//

import UIKit
import Then

class StepperTableViewCell: UITableViewCell {
    static let identifier = "StepperTableViewCell"
    
    private let titleLabel = UILabel().then {
        $0.text = "Daily Sleep Goal: \(UserDefaults.standard.integer(forKey: "personSleep"))h"
    }
    
    private let uiStepper = UIStepper().then {
        $0.value = Double(UserDefaults.standard.integer(forKey: "personSleep"))
        $0.minimumValue = 4
        $0.maximumValue = 10
        $0.stepValue = 1
        
        $0.addTarget(self, action: #selector(stepperValueChange), for: .valueChanged)
    }
    
    @objc private func stepperValueChange(_ sender: UIStepper) {
        let sleepValue = Int(sender.value)
        UserDefaults.standard.set(sleepValue, forKey: "personSleep")
        titleLabel.text = "Daily Sleep Goal: \(sleepValue)h"
        
        MissionViewModel.shared.completeMission(title: "Goal Setter")
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
        
        contentView.addSubviews(titleLabel, uiStepper)

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        uiStepper.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
}
