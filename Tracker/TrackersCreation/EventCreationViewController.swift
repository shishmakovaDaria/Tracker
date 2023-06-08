//
//  EventCreationViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 02.06.2023.
//

import Foundation
import UIKit

final class EventCreationViewController: UIViewController {
    
    private let tableView = UITableView()
    private let trackersName = CustomTextField()
    private let errorLabel = UILabel()
    private let createButton = UIButton()
    private var newTrackersName: String?
    private var category: String?
    private let emoji = ["⚽️", "💧", "🌺", "🥵", "😻"]
    private let colors: [UIColor] = [.selection1, .selection2, .selection3, .selection4, .selection5, .selection6, .selection7, .selection8, .selection9, .selection10]
    
    private var tableViewTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
    private func configureView() {
        let label = UILabel()
        label.text = "Новое нерегулярное событие"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
        
        trackersName.placeholder = "Введите название трекера"
        trackersName.textColor = .ypBlack
        trackersName.font = .systemFont(ofSize: 17)
        trackersName.backgroundColor = .backgroundDay
        trackersName.layer.cornerRadius = 16
        trackersName.clearButtonMode = .whileEditing
        trackersName.returnKeyType = .go
        trackersName.delegate = self
        trackersName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        view.addSubview(trackersName)
        trackersName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackersName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersName.heightAnchor.constraint(equalToConstant: 75),
            trackersName.topAnchor.constraint(equalTo: view.topAnchor, constant: 87)
        ])
        
        errorLabel.text = "Ограничение 38 символов"
        errorLabel.font = .systemFont(ofSize: 17)
        errorLabel.textColor = .ypRed
        
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: trackersName.bottomAnchor, constant: 8)
        ])
        
        errorLabel.isHidden = true
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "CancelButton"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        createButton.setImage(UIImage(named: "CreateButtonBlack"), for: .normal)
        createButton.setImage(UIImage(named: "CreateButtonGray"), for: .disabled)
        createButton.addTarget(self, action: #selector(createButtonDidTap(_:)), for: .touchUpInside)
        createButton.isEnabled = false
        stackView.addArrangedSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
        
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableViewTopConstraint = NSLayoutConstraint(
            item: tableView,
            attribute: .top,
            relatedBy: .equal,
            toItem: trackersName,
            attribute: .bottom,
            multiplier: 1,
            constant: 24)
        
        guard let tableViewTopConstraint = tableViewTopConstraint else { return }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewTopConstraint,
            tableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    @objc private func cancelButtonDidTap(_ sender: Any?) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonDidTap(_ sender: Any?) {
        if newTrackersName?.isEmpty == false,
           category?.isEmpty == false {
            let newTracker = Tracker(
                id: UUID(),
                name: newTrackersName ?? "",
                color: colors.randomElement() ?? UIColor(),
                emogi: emoji.randomElement() ?? "",
                schedule: nil)
            TrackersStorage.shared.addNewTracker(tracker: newTracker, header: self.category ?? "")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard trackersName.isValid() else {
            errorLabel.isHidden = false
            tableViewTopConstraint?.constant = 62
            view.layoutIfNeeded()
            return
        }
        tableViewTopConstraint?.constant = 24
        errorLabel.isHidden = true
        view.layoutIfNeeded()
    }
}

//MARK: - UITableViewDataSource
extension EventCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        cell.header.text = "Категория"
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        
        if category != nil {
            cell.addSecondLabel(chosen: category ?? "")
            tableView.reloadData()
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension EventCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let VC = CategoryViewController()
        VC.delegate = self
        VC.modalTransitionStyle = .flipHorizontal
        present(VC, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension EventCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackersName.resignFirstResponder()
        
        if let text = trackersName.text {
            newTrackersName = text
        }
        
        if category?.isEmpty == false {
            createButton.isEnabled = true
        }
        return true
    }
}

//MARK: - CategoryViewControllerDelegate
extension EventCreationViewController: CategoryViewControllerDelegate {
    func addCategory(chosenCategory: String) {
        self.category = chosenCategory
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CustomTableViewCell else { return }
        cell.addSecondLabel(chosen: category ?? "")
        
        if newTrackersName?.isEmpty == false {
            createButton.isEnabled = true
        }
    }
}
