//
//  OnboardingViewController2.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/8/25.
//

import UIKit

class OnboardingViewController2: UIViewController {
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.text = "With Apple Watch"
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(imageView)
        view.addSubview(titlelabel)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titlelabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}
