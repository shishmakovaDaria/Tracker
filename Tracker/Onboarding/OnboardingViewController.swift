//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 01.07.2023.
//

import Foundation
import UIKit

final class OnboardingViewController: UIPageViewController {
    lazy var pages: [UIViewController] = {
        let page1 = OnboardingPageViewController()
        page1.label.text = "Отслеживайте только то, что хотите"
        page1.setBackgroundImage(image: UIImage(named: "Onboarding1") ?? UIImage())
        
        let page2 = OnboardingPageViewController()
        page2.label.text = "Даже если это не литры воды и йога"
        page2.setBackgroundImage(image: UIImage(named: "Onboarding2") ?? UIImage())
        
        return [page1, page2]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPageControl()
        setUpButton()
        dataSource = self
        delegate = self
        if let first = pages.first {
            setViewControllers([first],
                               direction: .forward,
                               animated: true)
        }
    }
    
    private func setUpPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168)
        ])
    }
    
    private func setUpButton() {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84)
        ])
    }
    
    @objc private func buttonDidTap(_ sender: Any?) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = TabBarController()
    }
}

//MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let newIndex = viewControllerIndex + 1
        
        guard newIndex < pages.count else { return nil }
        
        return pages[newIndex]
        
    }
}

//MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
