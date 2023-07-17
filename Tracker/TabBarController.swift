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
        self.tabBar.backgroundColor = .ypWhite
        
        let separator = UIView()
        separator.backgroundColor = .separatorColor
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.topAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: -1)
        ])
    }
}
