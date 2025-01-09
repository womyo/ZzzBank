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
        
//        print(viewModel.getLoanRecord()[0].loanTime)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
        
        return cell
    }
}
