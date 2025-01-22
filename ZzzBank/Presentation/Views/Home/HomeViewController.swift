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

class HomeViewController: UIViewController {
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
        
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToLoanRecordView))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        configureUI()
        tableView.reloadData()
    }
    
    private func configureUI() {
        view.addSubview(infoLabel)
        view.addSubview(mentLabel)
        view.addSubview(containerView)
        containerView.addSubview(tableView)
        view.addSubview(loanButton)
        
        let skView = SKView(frame: self.view.bounds)
        skView.layer.zPosition = -1
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        skView.layer.cornerRadius = 75
        skView.clipsToBounds = true
        let scene = GameScene(viewModel: viewModel, size: CGSize(width: 300, height: 300))
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .gray
        
        skView.presentScene(scene)
        view.addSubview(skView)
        
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
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
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
        
        let borrowed = 24 - viewModel.getLoanLimit()
        let debt = viewModel.getDebt()
        
        infoLabel.text = "Borrowed: \(borrowed) Debt: \(debt)"
        
        switch debt {
        case 0..<5:
            mentLabel.text = "You’re doing fine! A little rest will keep you on track."
            viewModel.condition = .healthy
        case 5..<10:
            mentLabel.text = "Your body’s asking for a break. How about a short nap?"
            viewModel.condition = .tired
        case 10..<20:
            mentLabel.text = "Feeling tired? Your energy needs a boost with some good sleep."
            viewModel.condition = .exhausted
        default:
            mentLabel.text = "Your sleep debt is too high! Let’s prioritize rest right away."
            viewModel.condition = .unwell
        }
    }
    
    @objc private func navigateToLoanRecordView() {
        let vc = LoanRecordViewController(viewModel: self.viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.combinedRecords.count > 0 ? min(viewModel.combinedRecords.count, 3) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else {
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
