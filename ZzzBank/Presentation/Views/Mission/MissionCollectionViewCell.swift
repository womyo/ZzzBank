//
//  MissionCollectionViewCell.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/10/25.
//

import UIKit

class MissionCollectionViewCell: UICollectionViewCell {
    static let identifier = "MissionCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    private let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        
        return view
    }()
    
    private let verticalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        
        return view
    }()
    
    private let diagonalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        
        return view
    }()
    
    private let reverseDiagonalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(label)
        contentView.addSubview(horizontalLineView)
        contentView.addSubview(verticalLineView)
        contentView.addSubview(diagonalLineView)
        contentView.addSubview(reverseDiagonalLineView)
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        horizontalLineView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        verticalLineView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(2)
        }
        
        diagonalLineView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.4)
            $0.height.equalTo(2)
        }
        
        diagonalLineView.transform = CGAffineTransform(rotationAngle: .pi * 0.25)
        
        reverseDiagonalLineView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.4)
            $0.height.equalTo(2)
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
