//
//  LoanViewController.swift
//  
//
//  Created by 이인호 on 1/7/25.
//

import UIKit
import SwiftUI
import SnapKit

class LoanViewController: UIViewController {
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("대출받기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "잠 대출"
        configureUI()
    }
    
    func configureUI() {
        let gaugeVC = UIHostingController(rootView: GaugeView())
        let gaugeView = gaugeVC.view!
        view.addSubview(gaugeView)
        gaugeVC.didMove(toParent: self)
        
        let circularSliderVC = UIHostingController(rootView: CircularSliderView())
        let circularSliderView = circularSliderVC.view!
        view.addSubview(circularSliderView)
        circularSliderVC.didMove(toParent: self)
        
        gaugeView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(circularSliderView.snp.top).offset(-32)
        }
        
        circularSliderView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(50)
        }
    }

}
