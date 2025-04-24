//
//  MissionViewController.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/10/25.
//

import UIKit
import SnapKit
import Then
import Lottie

class MissionViewController: UIViewController {
    private let viewModel: MissionViewModel
    
    let topSpacer = UIView()
    let bottomSpacer = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "B  I  N  G  O  !"
        $0.font = .systemFont(ofSize: 48, weight: .semibold)
    }
    
    private let animationView = LottieAnimationView(name: "check_animation").then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.isHidden = true
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .customBackgroundColor
        collectionView.register(MissionCollectionViewCell.self, forCellWithReuseIdentifier: MissionCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    init(viewModel: MissionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        viewModel.initMissions()
        viewModel.completeMockMissions()
        viewModel.loadMissions()
    }
    
    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubviews(titleLabel, collectionView, bottomSpacer, animationView)
        
        let spacing: CGFloat = 8
        let numberOfColumns: CGFloat = 5
        
        let totalSpacing: CGFloat = (numberOfColumns - 1) * spacing
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        let totalHeight = itemWidth * numberOfColumns + spacing * (numberOfColumns - 1)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(collectionView.snp.top).offset(-10)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(totalHeight)
        }
        
        bottomSpacer.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(bottomSpacer.snp.centerY)
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
        cell.layer.backgroundColor = viewModel.missions[indexPath.item].completed ? UIColor.main.cgColor : UIColor.systemGray.cgColor
        cell.configure(with: viewModel.missions[indexPath.item].title)
        
        cell.setLines(horizontal: viewModel.missions[indexPath.item].horizontal,
                      vertical: viewModel.missions[indexPath.item].vertical,
                      diagonal: viewModel.missions[indexPath.item].diagonal,
                      reverseDiagonal: viewModel.missions[indexPath.item].reverseDiagonal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let numberOfColumns: CGFloat = 5
        
        let totalSpacing: CGFloat = (numberOfColumns - 1) * spacing
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.checkBingo(at: indexPath.item)

        if viewModel.didFindNewBingo {
            self.animationView.alpha = 1
            self.animationView.isHidden = false
            self.animationView.play()

            DispatchQueue.main.asyncAfter(deadline: .now() + (animationView.animation?.duration ?? 0) - 0.2) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.animationView.alpha = 0
                }) { _ in
                    self.animationView.isHidden = true
                    self.animationView.stop()
                }
            }
        }
        
        collectionView.reloadData()
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
