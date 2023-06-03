//
//  CreationViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 02.06.2023.
//

import Foundation
import UIKit

final class HabitCreationViewController: UIViewController {
    
    private let tableView = UITableView()
    private let trackersName = CustomTextField()
    private let errorLabel = UILabel()
    private let createButton = UIButton()
    private var newTrackersName: String?
    private let tableHeaders = ["Категория", "Расписание"]
    let schedule: [String] = []
    let category = "Важное"
    
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
        label.text = "Новая привычка"
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
            errorLabel.topAnchor.constraint(equalTo: trackersName.bottomAnchor)
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
        
        createButton.setImage(UIImage(named: "CreateButton"), for: .normal)
        createButton.addTarget(self, action: #selector(createButtonDidTap(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
        
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: trackersName.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @IBAction private func cancelButtonDidTap(_ sender: Any?) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func createButtonDidTap(_ sender: Any?) {
        // to do
        
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        guard trackersName.isValid() else {
            createButton.isEnabled = false
            errorLabel.isHidden = false
            return
        }
        createButton.isEnabled = true
        errorLabel.isHidden = true
    }
}

//MARK: - UITableViewDataSource
extension HabitCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableHeaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        cell.header.text = tableHeaders[indexPath.row]
        if indexPath.row == 0 {
            cell.text.text = category
        } else {
            cell.text.text = schedule.joined(separator: ", ")
        }

        if indexPath.row == tableHeaders.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension HabitCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let VC = CategoryViewController()
            VC.modalTransitionStyle = .flipHorizontal
            present(VC, animated: true)
        } else {
            let VC = ScheduleViewController()
            VC.modalTransitionStyle = .flipHorizontal
            present(VC, animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate
extension HabitCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackersName.resignFirstResponder()
        
        if let text = trackersName.text {
            newTrackersName = text
        }
        return true
    }
}
