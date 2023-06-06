//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 04.06.2023.
//

import Foundation
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func addSchedule(chosenSchedule: Set<WeekDay>)
}

final class ScheduleViewController: UIViewController {
    
    private let tableView = UITableView()
    private let days = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private var schedule = Set<WeekDay>()
    var delegate: ScheduleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addTableView()
    }
    
    private func configureView() {
        let label = UILabel()
        label.text = "Расписание"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
        
        let doneButton = UIButton()
        doneButton.backgroundColor = .ypBlack
        doneButton.setTitle("Готово", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(doneButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func addTableView() {
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 79),
            tableView.heightAnchor.constraint(equalToConstant: 525)
        ])
    }
    
    @IBAction private func doneButtonDidTap(_ sender: Any?) {
        delegate?.addSchedule(chosenSchedule: schedule)
        dismiss(animated: true)
    }
    
    @IBAction private func switchChanged(_ sender: UISwitch) {
        if sender.tag == 0 {
            if sender.isOn {
                schedule.insert(.monday)
            } else {
                schedule.remove(.monday)
            }
        }
        
        if sender.tag == 1 {
            if sender.isOn {
                schedule.insert(.tuesday)
            } else {
                schedule.remove(.tuesday)
            }
        }
        
        if sender.tag == 2 {
            if sender.isOn {
                schedule.insert(.wednesday)
            } else {
                schedule.remove(.wednesday)
            }
        }
        
        if sender.tag == 3 {
            if sender.isOn {
                schedule.insert(.thursday)
            } else {
                schedule.remove(.thursday)
            }
        }
        
        if sender.tag == 4 {
            if sender.isOn {
                schedule.insert(.friday)
            } else {
                schedule.remove(.friday)
            }
        }
        
        if sender.tag == 5 {
            if sender.isOn {
                schedule.insert(.saturday)
            } else {
                schedule.remove(.saturday)
            }
        }
        
        if sender.tag == 6 {
            if sender.isOn {
                schedule.insert(.sunday)
            } else {
                schedule.remove(.sunday)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = days[indexPath.row]
        cell.backgroundColor = .backgroundDay
        let toggle = UISwitch()
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        toggle.onTintColor = .ypBlue
        cell.accessoryView = toggle
        
        if indexPath.row == days.count - 1 {
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

enum WeekDay: String {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
    
    private var sortOrder: Int {
        switch self {
        case .monday:
            return 0
        case .tuesday:
            return 1
        case .wednesday:
            return 2
        case .thursday:
            return 3
        case .friday:
            return 4
        case .saturday:
            return 5
        case .sunday:
            return 6
        }
    }
    
    static func <(lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}
