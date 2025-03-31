//
//  CustomPickerViewController.swift
//  ZzzBank
//
//  Created by 이인호 on 3/27/25.
//

import UIKit

class CustomPickerViewController: UIViewController {
    private let viewModel: LoanViewModel
    let pickerData = ["5", "6", "7" ,"8", "9", "10", "11", "12", "13", "14"]
    
    init(viewModel: LoanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sleep Repay"
        label.font = .systemFont(ofSize: 18, weight: .medium)

        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select how many hours to repay"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)

        return label
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        return pickerView
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Repay", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 12
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let value = pickerData[selectedRow]
            let amount = Int(value)! - UserDefaults.standard.integer(forKey: "personSleep")
            if amount > 0 {
                viewModel.payLoad(amount: amount)
                dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Not enough sleep to repay", message: "You need at least \(UserDefaults.standard.integer(forKey: "personSleep") + 1) hours of sleep to repay.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }, for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .shadowColor
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(pickerView)
        view.addSubview(checkButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        pickerView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(130)
        }
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-32)
            $0.height.equalTo(50)
        }
    }
}


extension CustomPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        10
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}
