//
//  RecordSettingViewController.swift
//  ZzzBank
//
//  Created by 이인호 on 1/22/25.
//

import UIKit
import SnapKit

class RecordSettingViewController: UIViewController {
    var selectedPath: IndexPath = IndexPath(row: 1, section: 0)
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.text = "조회 조건 설정"
        return label
    }()
    
    private let termLabel: UILabel = {
        let label = UILabel()
        label.text = "조회기간"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        
        configureUI()
    }
    
    func configureUI() {
        view.addSubview(settingLabel)
        view.addSubview(termLabel)
        view.addSubview(collectionView)
        
        settingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        termLabel.snp.makeConstraints {
            $0.top.equalTo(settingLabel.snp.bottom).offset(24)
            $0.leading.equalTo(settingLabel)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(termLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension RecordSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let alist: [String] = ["1주일", "1개월", "3개월"]
        cell.configure(with: alist[indexPath.row])
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2
        cell.layer.borderColor = (indexPath == selectedPath) ? UIColor.systemBlue.cgColor : UIColor.systemGray.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 16 * 2 + 10 * 2
        let itemWidth = (collectionView.frame.width - totalSpacing) / 3
        return CGSize(width: itemWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPath = indexPath
        collectionView.reloadData()
    }
}
