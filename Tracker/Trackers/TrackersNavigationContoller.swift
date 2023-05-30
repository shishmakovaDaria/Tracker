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
        addDate()
    }
    
    private func addPlusButton() {
        let plusButton = UIButton.systemButton(
            with: UIImage(named: "Plus")!,
            target: self,
            action: nil)
        //plusButton.addTarget(self, action: #selector(plusButtonDidTap(_:)), for: .touchUpInside)
        plusButton.tintColor = .black
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 18),
            plusButton.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            plusButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        ])
    }
    
    private func addDate() {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        ])
    }
}
