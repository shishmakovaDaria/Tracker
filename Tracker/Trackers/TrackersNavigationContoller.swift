//
//  TrackersNavigationContoller.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 23.05.2023.
//

import Foundation
import UIKit

final class TrackersNavigationContoller: UINavigationController {
    
    let controller = TrackersViewController()
    
    override func viewDidLoad() {
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
    
    @IBAction private func plusButtonDidTap(_ sender: Any?) {
        controller.showTrackersCreationViewController()
    }
}

//MARK: - HabitCreationViewControllerDelegate
extension TrackersNavigationContoller: HabitCreationViewControllerDelegate {
    func addTracker(tracker: Tracker) {
        controller.addNewTracker(newTracker: tracker)
    }
}
