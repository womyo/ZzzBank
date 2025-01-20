//
//  TabBarController.swift
//  ZzzBank
//
//  Created by 이인호 on 1/16/25.
//

import UIKit

class TabBarController: UITabBarController {

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
        appearance.shadowColor = .lightGray
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTabBarItems() {
        let firstViewController = ViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let secondViewController = UIViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        viewControllers = [firstViewController, secondViewController]
    }
}
