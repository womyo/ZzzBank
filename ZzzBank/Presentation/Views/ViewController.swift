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

class ViewController: UIViewController {
    private let viewModel: LoanViewModel = LoanViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sleep Balance"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let borrowedView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.8
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let borrowedLabel: UILabel = {
        let label = UILabel()
        label.text = "Borrowed"
        
        return label
    }()
    
    private let borrowedValue: UILabel = {
        let label = UILabel()
        label.text = "13 hours"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        
        return label
    }()
    
    private let repaidLabel: UILabel = {
        let label = UILabel()
        label.text = "Repaid"
        label.layer.borderWidth = 0.8
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 8
        
        return label
    }()
    
    private let debtLabel: UILabel = {
        let label = UILabel()
        label.text = "Debt"
        label.layer.borderWidth = 0.8
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 8
        
        return label
    }()
    
    private lazy var repayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Repay Sleep", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 25
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            let vc = LoanRecordViewController(viewModel: self.viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
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
    }
    
    private func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(borrowedView)
        borrowedView.addSubview(borrowedLabel)
        borrowedView.addSubview(borrowedValue)
        view.addSubview(repaidLabel)
        view.addSubview(debtLabel)
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(repaidLabel.snp.leading).offset(-8)
            $0.width.equalTo(repaidLabel)
            $0.height.equalTo(borrowedView.snp.width).multipliedBy(7.0/8.0)
        }
        
        borrowedLabel.snp.makeConstraints {
            $0.top.equalTo(borrowedView.snp.top).offset(32)
            $0.leading.equalTo(borrowedView.snp.leading).offset(16)
        }
        
        borrowedValue.snp.makeConstraints {
            $0.top.equalTo(borrowedLabel.snp.bottom).offset(16)
            $0.leading.equalTo(borrowedView.snp.leading).offset(16)
        }
        
        repaidLabel.snp.makeConstraints {
            $0.top.equalTo(borrowedView.snp.top)
            $0.leading.equalTo(borrowedView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(borrowedView)
            $0.height.equalTo(repaidLabel.snp.width).multipliedBy(7.0/8.0)
        }
        
        debtLabel.snp.makeConstraints {
            $0.top.equalTo(borrowedView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(debtLabel.snp.width).multipliedBy(1.0/3.0)
        }
        
        repayButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(loanButton.snp.leading).offset(-8)
            $0.width.equalTo(loanButton)
            $0.height.equalTo(50)
        }
        
        loanButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.equalTo(repayButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(repayButton)
            $0.height.equalTo(50)
        }
    }
}

