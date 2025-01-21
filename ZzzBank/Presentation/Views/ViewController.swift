//
//  ViewController.swift
//  ZzzBank
//
//  Created by 이인호 on 1/6/25.
//

import UIKit
import SpriteKit
import SwiftUI
import SnapKit
import Combine

class ViewController: UIViewController {
    private let viewModel: LoanViewModel = LoanViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    private let mentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let containerView = UIView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .customBackgroundColor
        tableView.setViewShadow(backView: containerView)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
        return tableView
    }()
    
    private let tableViewHeaderView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sleep History"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .semibold)

        return label
    }()
    
    private lazy var loanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Borrow Sleep", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 12
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            let vc = LoanViewController(viewModel: self.viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }, for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        configureUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToLoanRecordView))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        tableView.reloadData()
    }
    
//    func bind() {
//        viewModel.$loanLimit
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] limit in
//                self?.borrowedValue.text = "\(24 - limit) hours"
//            }
//            .store(in: &cancellables)
//    }
    
    private func configureUI() {
        view.addSubview(infoLabel)
        view.addSubview(mentLabel)
        view.addSubview(containerView)
        containerView.addSubview(tableView)
        view.addSubview(loanButton)
        
        let skView = SKView(frame: self.view.bounds)
        skView.layer.zPosition = -1
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(skView)
        
        let scene = GameScene(size: CGSize(width: 300, height: 300))
        
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .gray
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        skView.layer.cornerRadius = 75
        skView.clipsToBounds = true
        
        skView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(skView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
//            $0.leading.equalToSuperview().offset(16)
        }
        
        mentLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(mentLabel.snp.bottom).offset(48)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(loanButton.snp.top).offset(-16)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loanButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    private func configure() {
        let loanRecords = viewModel.getLoanRecords()
        let repayRecords = viewModel.getRepaymentRecords()
        
        viewModel.combinedRecords = Array(loanRecords) + Array(repayRecords)
        viewModel.combinedRecords = viewModel.combinedRecords.sorted { $0.date > $1.date }
        
        infoLabel.text = "Borrowed: \(24 - viewModel.getLoanLimit()) Debt: \(viewModel.getDebt())"
        mentLabel.text = "Sleep debt is accumulating. Consider going to bed earlier."
    }
    
    @objc private func navigateToLoanRecordView() {
        let vc = LoanRecordViewController(viewModel: self.viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.combinedRecords.count > 0 ? min(viewModel.combinedRecords.count, 3) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let combinedRecord = viewModel.combinedRecords[indexPath.row]
        cell.configure(with: combinedRecord, index: indexPath.row, count: min(viewModel.combinedRecords.count, 3))
        cell.selectionStyle = .none
        cell.backgroundColor = .customBackgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableViewHeaderView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
        }
        
        return tableViewHeaderView
    }
}
