//
//  OnboardingViewController2.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/8/25.
//

import UIKit

class OnboardingViewController2: UIViewController {
    private let viewModel: OnboardingViewModel
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.text = "With Apple Watch"
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "watch"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            self.viewModel.setPersonalSleepGoal(1)
        }, for: .touchUpInside)
        
        return button
    }()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(imageView)
        view.addSubview(titlelabel)
        view.addSubview(startButton)
        
        titlelabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(48)
            $0.centerX.equalToSuperview()
        }
    }
}
