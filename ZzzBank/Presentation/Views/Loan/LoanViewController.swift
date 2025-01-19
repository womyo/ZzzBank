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
    private var viewModel: LoanViewModel
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("대출 신청", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 25
        button.addAction(UIAction { [weak self] _ in
            if let timeValue = self?.viewModel.timeValue, timeValue > 0 {
                self?.viewModel.saveLoan()
                self?.viewModel.updateLoanLimit()
                self?.navigationController?.popViewController(animated: true)
                // 대출 상환 5일뒤 알림 등록해야함
            } else {
                
            }
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
        navigationItem.title = "잠은행"
        configureUI()
    }
    
    func configureUI() {
        let queueSystemVC = UIHostingController(rootView: QueueNumberSystemView())
        let queueSystemView = queueSystemVC.view!
        queueSystemView.backgroundColor = .customBackgroundColor
        view.addSubview(queueSystemView)
        queueSystemVC.didMove(toParent: self)
        
        let gaugeVC = UIHostingController(rootView: GaugeView())
        let gaugeView = gaugeVC.view!
        view.addSubview(gaugeView)
        gaugeVC.didMove(toParent: self)
        
        let circularSliderVC = UIHostingController(rootView: CircularSliderView(viewModel: viewModel))
        let circularSliderView = circularSliderVC.view!
        circularSliderView.backgroundColor = .customBackgroundColor
        view.addSubview(circularSliderView)
        circularSliderVC.didMove(toParent: self)
        
        queueSystemView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        gaugeView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(queueSystemView.snp.bottom).offset(48)
        }
        
        circularSliderView.snp.makeConstraints {
            $0.top.equalTo(gaugeView.snp.bottom).offset(48)
            $0.centerX.equalToSuperview()
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
