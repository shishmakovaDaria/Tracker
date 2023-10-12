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
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.backgroundColor = .ypBlack
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(.ypWhite, for: .normal)
        habitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        habitButton.layer.cornerRadius = 16
        habitButton.addTarget(self, action: #selector(habitButtonDidTap(_:)), for: .touchUpInside)
        return habitButton
    }()
    
    private lazy var eventButton: UIButton = {
        let eventButton = UIButton()
        eventButton.backgroundColor = .ypBlack
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.setTitleColor(.ypWhite, for: .normal)
        eventButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        eventButton.layer.cornerRadius = 16
        eventButton.addTarget(self, action: #selector(eventButtonDidTap(_:)), for: .touchUpInside)
        return eventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    @objc private func habitButtonDidTap(_ sender: Any?) {
        let vc = HabitCreationViewController()
        vc.viewModel = HabitCreationViewModel()
        vc.viewModel?.delegate = self.controller
        present(vc, animated: true)
    }
    
    @objc private func eventButtonDidTap(_ sender: Any?) {
        let vc = EventCreationViewController()
        vc.viewModel = EventCreationViewModel()
        vc.viewModel?.delegate = self.controller
        present(vc, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [label, habitButton, eventButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -357),
            
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            eventButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
}
