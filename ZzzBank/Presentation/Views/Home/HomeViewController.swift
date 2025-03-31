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
    private let viewModel: LoanViewModel
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
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 12
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            let vc = LoanViewController(viewModel: self.viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
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
        view.backgroundColor = .customBackgroundColor
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
        skView.clipsToBounds = true
        let scene = GameScene(viewModel: viewModel, size: CGSize(width: 200, height: 200))
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .customBackgroundColor
        
        skView.presentScene(scene)
        view.addSubview(skView)
        
        skView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(skView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        mentLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(350)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(loanButton.snp.top).offset(-24)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loanButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    private func configure() {
        viewModel.getCombinedRecords(type: .all)
        
        let borrowed = 24 - viewModel.getLoanLimit()
        let debt = viewModel.getDebt()
        
        infoLabel.text = "Borrowed: \(borrowed) Interest: \(debt)"
        
        switch debt {
        case 0..<5:
            mentLabel.text = "You’re doing fine. Keep it up!"
            viewModel.condition = .healthy
        case 5..<10:
            mentLabel.text = "Time for a quick break or nap."
            viewModel.condition = .tired
        case 10..<20:
            mentLabel.text = "Low energy. Get some good sleep."
            viewModel.condition = .exhausted
        default:
            mentLabel.text = "You’re burnt out. Step away and rest."
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
        return viewModel.combinedRecords.count > 0 ? min(viewModel.combinedRecords.count, 3) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.combinedRecords.count == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No History"
            cell.textLabel?.textColor = .gray
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            cell.backgroundColor = .customBackgroundColor
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else {
                return UITableViewCell()
            }
            
            let combinedRecord = viewModel.combinedRecords[indexPath.row]
            cell.configure(with: combinedRecord, index: indexPath.row, count: min(viewModel.combinedRecords.count, 3))
            cell.selectionStyle = .none
            cell.backgroundColor = .customBackgroundColor
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableViewHeaderView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        return tableViewHeaderView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToLoanRecordView()
    }
}
