//
//  StepperTableViewCell.swift
//  ZzzBank
//
//  Created by 이인호 on 3/27/25.
//

import UIKit

class StepperTableViewCell: UITableViewCell {
    static let identifier = "StepperTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Sleep Goal: \(UserDefaults.standard.integer(forKey: "personSleep"))h"
        
        return label
    }()
    
    private let uiStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = Double(UserDefaults.standard.integer(forKey: "personSleep"))
        stepper.minimumValue = 4
        stepper.maximumValue = 10
        stepper.stepValue = 1
        
        stepper.addTarget(self, action: #selector(stepperValueChange), for: .valueChanged)
        
        return stepper
    }()
    
    @objc private func stepperValueChange(_ sender: UIStepper) {
        let sleepValue = Int(sender.value)
        UserDefaults.standard.set(sleepValue, forKey: "personSleep")
        titleLabel.text = "Daily Sleep Goal: \(sleepValue)h"
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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(uiStepper)
        
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
