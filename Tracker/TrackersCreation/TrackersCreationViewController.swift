//
//  TrackersCreationViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 01.06.2023.
//

import Foundation
import UIKit

final class TrackersCreationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
    }
    
    private func configureView() {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
        
        let habitButton = UIButton()
        habitButton.backgroundColor = .black
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.layer.cornerRadius = 16
        view.addSubview(habitButton)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -357)
        ])
        
        let eventButton = UIButton()
        eventButton.backgroundColor = .black
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.layer.cornerRadius = 16
        view.addSubview(eventButton)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            eventButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
}
