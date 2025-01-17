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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sleep Balance"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let borrowedView: SleepInfoView = SleepInfoView()
    private let debtView: SleepInfoView = SleepInfoView()
    private let repaidView: SleepInfoView = SleepInfoView()
    
    private lazy var repayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Repay Sleep", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 25
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
        }, for: .touchUpInside)
        
        return button
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
        borrowedView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        borrowedView.setLabels("Borrowed", 24 - viewModel.getLoanLimit())
        debtView.setLabels("Debt", viewModel.getDebt())
        repaidView.setLabels("Repaid", "Temp")
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
        view.addSubview(borrowedView)
        view.addSubview(repaidView)
        view.addSubview(debtView)
        view.addSubview(repayButton)
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
        
        borrowedView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(repaidView.snp.leading).offset(-16)
            $0.width.equalTo(repaidView)
            $0.height.equalTo(borrowedView.snp.width).multipliedBy(7.0/8.0)
        }
        
        repaidView.snp.makeConstraints {
            $0.top.equalTo(borrowedView.snp.top)
            $0.leading.equalTo(borrowedView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(borrowedView)
            $0.height.equalTo(repaidView.snp.width).multipliedBy(7.0/8.0)
        }
        
        debtView.snp.makeConstraints {
            $0.top.equalTo(borrowedView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(debtView.snp.width).multipliedBy(1.0/3.0)
        }
        
        repayButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(loanButton.snp.leading).offset(-16)
            $0.width.equalTo(loanButton)
            $0.height.equalTo(50)
        }
        
        loanButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.equalTo(repayButton.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(repayButton)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func navigateToLoanRecordView() {
        let vc = LoanRecordViewController(viewModel: self.viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

