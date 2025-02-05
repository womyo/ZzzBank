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
    
    private let dateSectionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = . customBackgroundColor
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
            if let text = self?.repaymentTextField.text, let repaymentValue = Int(text) {
                self?.viewModel.payLoad(amount: repaymentValue - UserDefaults.standard.integer(forKey: "personSleep"))
                self?.navigationController?.popViewController(animated: true)
            }
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var settingButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "1개월·전체·최신순"
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.baseForegroundColor = .white
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.addAction(UIAction { [weak self] _ in
            let sheetViewController = RecordSettingViewController()
            if let sheet = sheetViewController.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            self?.present(sheetViewController, animated: true, completion: nil)
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
        navigationItem.title = "Records"
        viewModel.changeCombinedRepaymentsToDict()
        
        configure()
        configureUI()
    }
    
    private func configure() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let today = Date()
        
        dateSectionLabel.text = "\(dateFormatter.string(from: monthAgo)) ~ \(dateFormatter.string(from: today)) (\(viewModel.combinedRecordsCount)건)"
    }
    
    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(dateSectionLabel)
        view.addSubview(tableView)
        view.addSubview(repaymentTextField)
        view.addSubview(repaymentButton)
        view.addSubview(settingButton)
        
        repaymentTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
        }
        
        repaymentButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(repaymentTextField.snp.trailing).offset(16)
        }
        
        settingButton.snp.makeConstraints {
            $0.top.equalTo(repaymentTextField.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        dateSectionLabel.snp.makeConstraints {
//            $0.top.equalTo(settingButton.snp.bottom).offset(16)
            $0.centerY.equalTo(settingButton.snp.centerY)
            $0.leading.equalToSuperview().offset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(dateSectionLabel.snp.bottom).offset(16)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension LoanRecordViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.combinedRecordsForDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        if let records = viewModel.combinedRecordsForDict[viewModel.keys[section]] {
            return records.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoanRecordTableViewCell.identifier, for: indexPath) as? LoanRecordTableViewCell else {
            return UITableViewCell()
        }
        
        if let records = viewModel.combinedRecordsForDict[viewModel.keys[indexPath.section]] {
            let record = records[indexPath.row]
            cell.configure(with: record)
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .customBackgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: viewModel.keys[section])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
