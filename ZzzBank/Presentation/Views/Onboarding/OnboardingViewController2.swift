//
//  OnboardingViewController2.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/8/25.
//

import UIKit

extension Notification.Name {
    static let didFinishOnboarding = Notification.Name("didFinishOnboarding")
}

class OnboardingViewController2: UIViewController {
    private let viewModel: OnboardingViewModel
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.text = "With Apple Watch"
        label.textColor = .label
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "watch"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Apple Watch for smart sleep"
        
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 12
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            self.startButton.animatePress(scale: 0.97) {
                self.viewModel.setPersonalSleepGoal(self.viewModel.value)
                self.viewModel.setLoanLimit()
                NotificationCenter.default.post(name: .didFinishOnboarding, object: nil)
            }
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
        view.addSubview(titlelabel)
        view.addSubview(imageView)
        view.addSubview(contentLabel)
        view.addSubview(startButton)
        
        titlelabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
}
