//
//  TabBarController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 11.05.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersNavigationContoller = TrackersNavigationContoller()
        trackersNavigationContoller.tabBarItem = UITabBarItem(title: "Трекеры",
                                                         image: UIImage(systemName: "record.circle.fill"),
                                                         selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                                           image: UIImage(systemName: "hare.fill"),
                                                           selectedImage: nil)
        
        self.viewControllers = [trackersNavigationContoller, statisticsViewController]
        self.tabBar.barTintColor = .white
        
        let grayView = UIView()
        grayView.backgroundColor = .ypGray
        view.addSubview(grayView)
        grayView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            grayView.heightAnchor.constraint(equalToConstant: 1),
            grayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayView.topAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: -1)
        ])
    }
}
