//
//  RecordSettingViewController.swift
//  ZzzBank
//
//  Created by 이인호 on 1/22/25.
//

import UIKit
import SnapKit

class RecordSettingViewController: UIViewController {
    var selectedPath1: IndexPath = IndexPath(row: 1, section: 0)
    var selectedPath2: IndexPath = IndexPath(row: 0, section: 0)
    var selectedPath3: IndexPath = IndexPath(row: 0, section: 0)
    
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
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "유형"
        return label
    }()
    
    private let sortLabel: UILabel = {
        let label = UILabel()
        label.text = "정렬"
        return label
    }()
    
    private lazy var collectionView1: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.tag = 1
        
        return collectionView
    }()
    
    private lazy var collectionView2: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.tag = 2
        
        return collectionView
    }()
    
    private lazy var collectionView3: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.tag = 3
        
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
        view.addSubview(collectionView1)
        view.addSubview(typeLabel)
        view.addSubview(collectionView2)
        view.addSubview(sortLabel)
        view.addSubview(collectionView3)
        
        settingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        termLabel.snp.makeConstraints {
            $0.top.equalTo(settingLabel.snp.bottom).offset(24)
            $0.leading.equalTo(settingLabel)
        }
        
        collectionView1.snp.makeConstraints {
            $0.top.equalTo(termLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView1.snp.bottom).offset(24)
            $0.leading.equalTo(settingLabel)
        }
        
        collectionView2.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        sortLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView2.snp.bottom).offset(24)
            $0.leading.equalTo(settingLabel)
        }
        
        collectionView3.snp.makeConstraints {
            $0.top.equalTo(sortLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension RecordSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1, 2: return 3
        case 3: return 2
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        var alist: [String] = []
        
        switch collectionView.tag {
        case 1:
            alist = ["1주일", "1개월", "3개월"]
            cell.layer.borderColor = (indexPath == selectedPath1) ? UIColor.systemBlue.cgColor : UIColor.systemGray.cgColor
        case 2:
            alist = ["전체", "Borrowed", "Repaid"]
            cell.layer.borderColor = (indexPath == selectedPath2) ? UIColor.systemBlue.cgColor : UIColor.systemGray.cgColor
        case 3:
            alist = ["최신순", "과거순"]
            cell.layer.borderColor = (indexPath == selectedPath3) ? UIColor.systemBlue.cgColor : UIColor.systemGray.cgColor
        default:
            break
        }
        
        cell.configure(with: alist[indexPath.row])
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 16 * 2 + 10 * 2
        let itemWidth: CGFloat = {
            switch collectionView.tag {
            case 1, 2:
                return (collectionView.frame.width - totalSpacing) / 3
            case 3:
                return (collectionView.frame.width - totalSpacing) / 2
            default:
                return 0
            }
        }()

        return CGSize(width: itemWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            selectedPath1 = indexPath
        case 2:
            selectedPath2 = indexPath
        case 3:
            selectedPath3 = indexPath
        default:
            break
        }
        
        collectionView.reloadData()
    }
}
