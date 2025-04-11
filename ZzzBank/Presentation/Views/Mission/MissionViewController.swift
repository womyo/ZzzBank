//
//  MissionViewController.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/10/25.
//

import UIKit

class MissionViewController: UIViewController {
    private let viewModel = MissionViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .customBackgroundColor
        collectionView.register(MissionCollectionViewCell.self, forCellWithReuseIdentifier: MissionCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
//        viewModel.initMissions()
//        viewModel.completeMission(title: "First Debt")
//        viewModel.completeMission(title: "Reset Used")
//        viewModel.completeMission(title: "Sleep Twice")
//        viewModel.completeMission(title: "Debt Master")
//        viewModel.completeMission(title: "Perfect Week")
        
//        viewModel.completeMission(title: "First Debt")
//        viewModel.completeMission(title: "First Repay")
//        viewModel.completeMission(title: "Three Days Log")
//        viewModel.completeMission(title: "No Delay")
//        viewModel.completeMission(title: "Use a Coupon")
        viewModel.getMissions()
        viewModel.isBingo()
    }
    
    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(collectionView)
        
        let spacing: CGFloat = 8
        let numberOfColumns: CGFloat = 5
        
        let totalSpacing: CGFloat = (numberOfColumns - 1) * spacing
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        let totalHeight = itemWidth * numberOfColumns + spacing * (numberOfColumns - 1)
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(totalHeight)
        }
    }
}

extension MissionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionCollectionViewCell.identifier, for: indexPath) as? MissionCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.backgroundColor = viewModel.missions[indexPath.item].completed ? UIColor.blue.cgColor : UIColor.systemGray.cgColor
        cell.configure(with: viewModel.missions[indexPath.item].title)
        
        let directions = viewModel.bingoLineMap[indexPath.item] ?? []
        
        cell.setLines(horizontal: directions.contains(.horizontal), vertical: directions.contains(.vertical), diagonal: directions.contains(.diagonal), reverseDiagonal: directions.contains(.reverseDiagonal))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let numberOfColumns: CGFloat = 5
        
        let totalSpacing: CGFloat = (numberOfColumns - 1) * spacing
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//    }
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
