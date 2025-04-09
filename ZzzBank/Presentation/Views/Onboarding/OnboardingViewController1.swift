//
//  OnboardingViewController1.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/8/25.
//

import UIKit

class OnboardingViewController1: UIViewController {
    private let viewModel = OnboardingViewModel()
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.text = "Sleep Goal"
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var goalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "How long do you usually sleep?"
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.addAction(UIAction { [weak self] _ in
            guard
                let self = self,
                let goalText = goalTextField.text,
                let goal = Int(goalText)
            else {
                return
            }
            
            self.viewModel.setPersonalSleepGoal(goal)
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [goalTextField, nextButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapBackground))
        view.addGestureRecognizer(tap)

        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(titlelabel)
        view.addSubview(stackView)
        
        titlelabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func onTapBackground() {
        goalTextField.resignFirstResponder()
    }
}

extension OnboardingViewController1: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
