//
//  OnboardingViewController1.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/8/25.
//

import UIKit
import Then

class OnboardingViewController1: UIViewController {
    private let viewModel: OnboardingViewModel
    let pickerData = ["5", "6", "7" ,"8", "9", "10", "11", "12", "13", "14"]
    
    private let titleLabel = UILabel().then {
        $0.text = "Sleep Goal"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 28, weight: .semibold)
    }
    
    private let imageView = UIImageView(image: UIImage(named: "manSleep")).then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "How long do you usually sleep?"
    }
    
    private lazy var stepperValueLabel: UILabel = {
        let label = UILabel()
        label.text = "\(viewModel.value)h"
        
        return label
    }()
    
    private lazy var uiStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = Double(viewModel.value)
        stepper.minimumValue = 4
        stepper.maximumValue = 10
        stepper.stepValue = 1
        
        stepper.addTarget(self, action: #selector(stepperValueChange), for: .valueChanged)
        
        return stepper
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stepperValueLabel, uiStepper])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        
        return stackView
    }()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func stepperValueChange(_ sender: UIStepper) {
        let sleepValue = Int(sender.value)
        stepperValueLabel.text = "\(sleepValue)h"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubviews(titleLabel, imageView, contentLabel, stackView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}

extension OnboardingViewController1: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
