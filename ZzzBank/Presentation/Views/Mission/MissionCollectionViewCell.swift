//
//  MissionCollectionViewCell.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/10/25.
//

import UIKit
import Then

class MissionCollectionViewCell: UICollectionViewCell {
    static let identifier = "MissionCollectionViewCell"
    
    private let label = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
    }
    
    private let horizontalLineView = UIView().then {
        $0.backgroundColor = .customBackgroundColor.withAlphaComponent(0.7)
        $0.isHidden = true
    }
    
    private let verticalLineView = UIView().then {
        $0.backgroundColor = .customBackgroundColor.withAlphaComponent(0.7)
        $0.isHidden = true
    }
    
    private let diagonalLineView = UIView().then {
        $0.backgroundColor = .customBackgroundColor.withAlphaComponent(0.7)
        $0.isHidden = true
    }
    
    private let reverseDiagonalLineView = UIView().then {
        $0.backgroundColor = .customBackgroundColor.withAlphaComponent(0.7)
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubviews(label, horizontalLineView, verticalLineView, diagonalLineView, reverseDiagonalLineView)

        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        horizontalLineView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        verticalLineView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(3)
        }
        
        diagonalLineView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.4)
            $0.height.equalTo(3)
        }
        
        diagonalLineView.transform = CGAffineTransform(rotationAngle: .pi * 0.25)
        
        reverseDiagonalLineView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.4)
            $0.height.equalTo(3)
        }
        
        reverseDiagonalLineView.transform = CGAffineTransform(rotationAngle: .pi * 1.75)
    }
    
    func configure(with text: String) {
        label.text = text
    }
    
    func setLines(horizontal: Bool, vertical: Bool, diagonal: Bool, reverseDiagonal: Bool) {
        horizontalLineView.isHidden = !horizontal
        verticalLineView.isHidden = !vertical
        diagonalLineView.isHidden = !diagonal
        reverseDiagonalLineView.isHidden = !reverseDiagonal
    }
}
