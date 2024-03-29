//
//  TrackersNavigationContoller.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 23.05.2023.
//

import Foundation
import UIKit

final class TrackersNavigationController: UINavigationController {
    
    let controller = TrackersViewController()
    private let analyticsService = AnalyticsService()
    
    override func viewDidLoad() {
        controller.viewModel = TrackersViewModel()
        viewControllers = [controller]
        addPlusButton()
    }
    
    private func addPlusButton() {
        let plusButton = UIButton.systemButton(
            with: UIImage(named: "Plus")!,
            target: self,
            action: nil)
        plusButton.addTarget(self, action: #selector(plusButtonDidTap(_:)), for: .touchUpInside)
        plusButton.tintColor = .ypBlack
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 18),
            plusButton.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            plusButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        ])
    }
    
    @objc private func plusButtonDidTap(_ sender: Any?) {
        analyticsService.didTapAddTrackerOnMain()
        controller.showTrackersCreationViewController()
    }
}
