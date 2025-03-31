//
//  TabBarController.swift
//  ZzzBank
//
//  Created by 이인호 on 1/16/25.
//

import UIKit

class TabBarController: UITabBarController {
    private let viewModel = LoanViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarLayout()
        setupTabBarItems()
        selectedIndex = 0
    }
    
    private func setupTabBarLayout() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .customBackgroundColor
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        appearance.stackedLayoutAppearance.normal.iconColor = .gray

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTabBarItems() {
        let firstViewController = HomeViewController(viewModel: viewModel)
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let secondViewController = SettingViewController(viewModel: viewModel)
        secondViewController.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        viewControllers = [firstViewController, secondViewController]
    }
}
