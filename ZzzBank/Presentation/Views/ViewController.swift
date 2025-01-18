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

extension UIView {
    func setViewShadow(backView: UIView) {
        layer.masksToBounds = true
        layer.cornerRadius = 20
        
        backView.layer.masksToBounds = false
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backView.layer.shadowRadius = 5
        backView.layer.shadowColor = UIColor.white.cgColor
    }
}

class ViewController: UIViewController {
    private let viewModel: LoanViewModel = LoanViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sleep Balance"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .semibold)
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
        tableView.setViewShadow(backView: containerView)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
        return tableView
    }()
    
    private lazy var loanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Borrow Sleep", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 25
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            let vc = LoanViewController(viewModel: self.viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }, for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToLoanRecordView))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        view.addSubview(titleLabel)
        containerView.addSubview(tableView)
        view.addSubview(containerView)
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(skView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(loanButton.snp.top).offset(-16)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview() // containerView 내부에 꽉 차도록 배치
        }
        
        loanButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func navigateToLoanRecordView() {
        let vc = LoanRecordViewController(viewModel: self.viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let loanRecords = viewModel.getLoanRecords()
        let repayRecords = viewModel.getRepaymentRecords()
        
        var combined: [DateSortable] = Array(loanRecords) + Array(repayRecords)
        combined = combined.sorted { $0.date > $1.date }
        let data = combined[indexPath.row]
        
        cell.configure(with: data, index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
