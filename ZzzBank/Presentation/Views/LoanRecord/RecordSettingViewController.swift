//
//  RecordSettingViewController.swift
//  ZzzBank
//
//  Created by 이인호 on 1/22/25.
//

import UIKit
import SnapKit
import Then

class RecordSettingViewController: UIViewController {
    private let viewModel: LoanViewModel
    
    init(viewModel: LoanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let settingLabel = UILabel().then {
        $0.text = "View Options"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let termLabel = UILabel().then {
        $0.text = "Range"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let typeLabel = UILabel().then {
        $0.text = "Type"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let sortLabel = UILabel().then {
        $0.text = "Sort"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 12
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.changeCombinedRepaymentsToDict(term: self.viewModel.term ,type: self.viewModel.recordType, sort: self.viewModel.recordSort)
            self.dismiss(animated: true, completion: nil)
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var termCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.tag = 1
        
        return collectionView
    }()
    
    private lazy var typeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.tag = 2
        
        return collectionView
    }()
    
    private lazy var sortCollectionView: UICollectionView = {
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
        view.addSubviews(settingLabel, termLabel, termCollectionView, typeLabel, typeCollectionView, sortLabel, sortCollectionView, checkButton)
        
        settingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        termLabel.snp.makeConstraints {
            $0.top.equalTo(settingLabel.snp.bottom).offset(24)
            $0.leading.equalTo(settingLabel)
        }
        
        termCollectionView.snp.makeConstraints {
            $0.top.equalTo(termLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(termCollectionView.snp.bottom).offset(24)
            $0.leading.equalTo(settingLabel)
        }
        
        typeCollectionView.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        sortLabel.snp.makeConstraints {
            $0.top.equalTo(typeCollectionView.snp.bottom).offset(24)
            $0.leading.equalTo(settingLabel)
        }
        
        sortCollectionView.snp.makeConstraints {
            $0.top.equalTo(sortLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(sortCollectionView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().offset(-32)
            $0.height.equalTo(50)
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
            alist = ["1 Week", "1 Month", "1 Year"]
            cell.layer.borderColor = (indexPath == viewModel.selectedPath1) ? UIColor.mainColor.cgColor : UIColor.systemGray.cgColor
        case 2:
            alist = ["All", "Borrowed", "Repaid"]
            cell.layer.borderColor = (indexPath == viewModel.selectedPath2) ? UIColor.mainColor.cgColor : UIColor.systemGray.cgColor
        case 3:
            alist = ["Newest", "Oldest"]
            cell.layer.borderColor = (indexPath == viewModel.selectedPath3) ? UIColor.mainColor.cgColor : UIColor.systemGray.cgColor
        default:
            break
        }
        
        cell.configure(with: alist[indexPath.row])
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1.5
        
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

        return CGSize(width: itemWidth, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            viewModel.selectedPath1 = indexPath
            
            switch viewModel.selectedPath1.row {
            case 0:
                viewModel.term = .week
            case 1:
                viewModel.term = .month
            case 2:
                viewModel.term = .year
            default:
                break
            }
        case 2:
            viewModel.selectedPath2 = indexPath
            
            switch viewModel.selectedPath2.row {
            case 0:
                viewModel.recordType = .all
            case 1:
                viewModel.recordType = .borrowed
            case 2:
                viewModel.recordType = .repaid
            default:
                break
            }
        case 3:
            viewModel.selectedPath3 = indexPath
            
            switch viewModel.selectedPath3.row {
            case 0:
                viewModel.recordSort = .newest
            case 1:
                viewModel.recordSort = .oldest
            default:
                break
            }
        default:
            break
        }
        
        collectionView.reloadData()
    }
}
