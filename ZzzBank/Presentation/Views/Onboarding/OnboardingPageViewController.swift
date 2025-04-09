//
//  OnboardingViewController.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/8/25.
//

import UIKit
import SnapKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let pages: [UIViewController] = [OnboardingViewController1(), OnboardingViewController2()]
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
        pageControl.currentPageIndicatorTintColor = .customBackgroundColor
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.addTarget(self, action: #selector(handlePageControl(_:)), for: .valueChanged)
        
        return pageControl
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    @objc private func handlePageControl(_ sender: UIPageControl) {
        let targetIndex = sender.currentPage
        
        if let visibleVC = viewControllers?.first, let currentIndex = pages.firstIndex(of: visibleVC) {
            let direction: UIPageViewController.NavigationDirection = targetIndex > currentIndex ? .forward : .reverse
            setViewControllers([pages[targetIndex]], direction: direction, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        
        return previousIndex >= 0 ? pages[previousIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        
        return currentIndex < pages.count ? pages[nextIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = viewControllers?.first, let page = pages.firstIndex(of: visibleVC) {
            pageControl.currentPage = page
        }
    }
}
