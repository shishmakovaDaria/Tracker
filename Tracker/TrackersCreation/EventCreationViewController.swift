//
//  EventCreationViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 02.06.2023.
//

import Foundation
import UIKit

final class EventCreationViewController: UIViewController {
    
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configureView() {
        let label = UILabel()
        label.text = "Новое нерегулярное событие"
        label.font = .systemFont(ofSize: 16)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
        
        let trackersName = TextFieldWithPadding()
        trackersName.text = "Введите название трекера"
        trackersName.textColor = .ypGray
        trackersName.font = .systemFont(ofSize: 17)
        trackersName.backgroundColor = .backgroundDay
        trackersName.layer.cornerRadius = 16
        view.addSubview(trackersName)
        trackersName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackersName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersName.heightAnchor.constraint(equalToConstant: 75),
            trackersName.topAnchor.constraint(equalTo: view.topAnchor, constant: 87)
        ])
        
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
        
        let createButton = UIButton()
        createButton.setImage(UIImage(named: "CreateButton"), for: .normal)
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
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: trackersName.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    @IBAction private func cancelButtonDidTap(_ sender: Any?) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension EventCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Категория"
        cell.backgroundColor = .backgroundDay
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension EventCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
