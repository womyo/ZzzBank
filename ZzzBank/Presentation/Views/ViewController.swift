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
    
    private lazy var loanButton: UIButton = {
        let button = UIButton()
        button.setTitle("대출", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addAction(UIAction { [weak self] _ in
            let vc = LoanViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }, for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        
        HealthKitService.shared.getSleepData()
    }
    
    private func configureUI() {
        view.addSubview(loanButton)
        
        let skView = SKView(frame: self.view.bounds)
        skView.layer.zPosition = -1
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(skView)
        
        let scene = GameScene(size: CGSize(width: 300, height: 300))
        
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .systemBackground
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
        loanButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
        }
        
        skView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(100)
        }
    }
}

