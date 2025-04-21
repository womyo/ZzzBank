//
//  LoanRecordViewController.swift
//  ZzzBank
//
//  Created by 이인호 on 1/9/25.
//

import UIKit
import SnapKit
import Combine
import Then

class LoanRecordViewController: UIViewController {
    private let viewModel: LoanViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let dateSectionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .gray
    }
    
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
     
    private lazy var settingButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.baseForegroundColor = .white
        
        let title = AttributedString("Options", attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 15)]))
        config.attributedTitle = title
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            let sheetViewController = RecordSettingViewController(viewModel: self.viewModel)
            if let sheet = sheetViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 24
            }
            self.present(sheetViewController, animated: true)
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
        navigationItem.title = "History"
        
        configure()
        configureUI()
        bind()
    }
    
    private func configure() {
        viewModel.term = .month
        viewModel.recordType = .all
        viewModel.recordSort = .newest
        
        viewModel.selectedPath1 = IndexPath(row: 1, section: 0)
        viewModel.selectedPath2 = IndexPath(row: 0, section: 0)
        viewModel.selectedPath3 = IndexPath(row: 0, section: 0)
        
        viewModel.changeCombinedRepaymentsToDict(term: viewModel.term, type: viewModel.recordType, sort: viewModel.recordSort)
    }
    
    private func bind() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let today = Date()
        
        viewModel.$combinedRecordsForDict
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
                self.dateSectionLabel.text = "\(dateFormatter.string(from: self.viewModel.ago)) ~ \(dateFormatter.string(from: today)) (\(self.viewModel.combinedRecordsCount) items)"
            }
            .store(in: &cancellables)
        
        viewModel.$keys
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubviews(dateSectionLabel, tableView, settingButton)
        
        settingButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        dateSectionLabel.snp.makeConstraints {
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
