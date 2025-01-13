//
//  LoanRecordViewController.swift
//  ZzzBank
//
//  Created by 이인호 on 1/9/25.
//

import UIKit
import SnapKit

class LoanRecordViewController: UIViewController {
    private let viewModel: LoanViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(LoanRecordTableViewCell.self, forCellReuseIdentifier: LoanRecordTableViewCell.identifier)
        
        return tableView
    }()
    
    private let repaymentTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "수면 시간"
        textfield.keyboardType = .numberPad
        
        return textfield
    }()
    
    private lazy var repaymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("잠 상환", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        
        button.addAction(UIAction { [weak self] _ in
            if let text = self?.repaymentTextField.text, let repaymentValue = Double(text) {
                self?.viewModel.payLoad(amount: repaymentValue)
                self?.navigationController?.popViewController(animated: true)
            }
        }, for: .touchUpInside)
        return button
    }()
    
    init(viewModel: LoanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(repaymentTextField)
        view.addSubview(repaymentButton)
        
        repaymentTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
        }
        
        repaymentButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(repaymentTextField.snp.trailing).offset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(repaymentButton.snp.bottom).offset(16)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension LoanRecordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getLoanRecords().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoanRecordTableViewCell.identifier, for: indexPath) as? LoanRecordTableViewCell else {
            return UITableViewCell()
        }
        
        let loanRecord = viewModel.getLoanRecords()[indexPath.row]
        cell.configure(with: loanRecord)
//        let calendar = Calendar.current
//        
//        viewModel.getLoanRecords().enumerated().forEach { index, loanRecord in
//            let dateComponents = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: loanRecord.date))
//            
//            if let days = dateComponents.day, Date() > loanRecord.date {
//                viewModel.updateLoanRecords(index: index, overdueDays: abs(days))
//            }
//        }
        
        return cell
    }
}
