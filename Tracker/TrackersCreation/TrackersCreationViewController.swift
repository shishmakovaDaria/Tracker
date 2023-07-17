//
//  TrackersCreationViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 01.06.2023.
//

import Foundation
import UIKit

final class TrackersCreationViewController: UIViewController {
    
    var controller: TrackersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureView()
    }
    
    private func configureView() {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
        
        let habitButton = UIButton()
        habitButton.backgroundColor = .ypBlack
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(.ypWhite, for: .normal)
        habitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        habitButton.layer.cornerRadius = 16
        habitButton.addTarget(self, action: #selector(habitButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(habitButton)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -357)
        ])
        
        let eventButton = UIButton()
        eventButton.backgroundColor = .ypBlack
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.setTitleColor(.ypWhite, for: .normal)
        eventButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        eventButton.layer.cornerRadius = 16
        eventButton.addTarget(self, action: #selector(eventButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(eventButton)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            eventButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
    
    @objc private func habitButtonDidTap(_ sender: Any?) {
        let VC = HabitCreationViewController()
        VC.delegate = self.controller
        present(VC, animated: true)
    }
    
    @objc private func eventButtonDidTap(_ sender: Any?) {
        let VC = EventCreationViewController()
        VC.delegate = self.controller
        present(VC, animated: true)
    }
}
