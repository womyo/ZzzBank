//
//  OnboardingViewController1.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/8/25.
//

import UIKit

class OnboardingViewController1: UIViewController {
    private let viewModel: OnboardingViewModel
    let pickerData = ["5", "6", "7" ,"8", "9", "10", "11", "12", "13", "14"]
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.text = "Sleep Goal"
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "manSleep"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var qLabel: UILabel = {
        let label = UILabel()
        label.text = "How long do you usually sleep?"
        
        return label
    }()
    
    private lazy var textLabel: UILabel = {
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
        let stackView = UIStackView(arrangedSubviews: [textLabel, uiStepper])
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
        textLabel.text = "\(sleepValue)h"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(titlelabel)
        view.addSubview(imageView)
        view.addSubview(qLabel)
        view.addSubview(stackView)
        
        titlelabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        qLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(qLabel.snp.bottom).offset(16)
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
