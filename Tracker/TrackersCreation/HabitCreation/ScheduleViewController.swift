//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 04.06.2023.
//

import Foundation
import UIKit

final class ScheduleViewController: UIViewController {
    var viewModel: ScheduleViewModel?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        tableView.separatorColor = .ypGray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.backgroundColor = .ypBlack
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.ypWhite, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(doneButtonDidTap(_:)), for: .touchUpInside)
        return doneButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    @objc private func doneButtonDidTap(_ sender: Any?) {
        viewModel?.addSchedule()
        dismiss(animated: true)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        viewModel?.updateCurrentSchedule(senderTag: sender.tag, senderIsOn: sender.isOn)
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [label, doneButton, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 79),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

//MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel?.days[indexPath.row]
        cell.backgroundColor = .background
        let toggle = UISwitch()
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        toggle.onTintColor = .ypBlue
        cell.accessoryView = toggle
        
        if let viewModel = viewModel {
            for day in viewModel.schedule {
                switch day {
                case .monday:
                    if indexPath.row == 0 { toggle.isOn = true }
                case .tuesday:
                    if indexPath.row == 1 { toggle.isOn = true }
                case .wednesday:
                    if indexPath.row == 2 { toggle.isOn = true }
                case .thursday:
                    if indexPath.row == 3 { toggle.isOn = true }
                case .friday:
                    if indexPath.row == 4 { toggle.isOn = true }
                case .saturday:
                    if indexPath.row == 5 { toggle.isOn = true }
                case .sunday:
                    if indexPath.row == 6 { toggle.isOn = true }
                }
            }
        }
        
        if indexPath.row == (viewModel?.days.count ?? 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
