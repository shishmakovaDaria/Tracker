//
//  TrackerEditing.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 19.07.2023.
//

import Foundation
import UIKit

final class TrackerEditingViewController: UIViewController {
    
    var trackerToEdit: Tracker?
    var category: String?
    var trackerRecord: Int?
    private let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollView = UIScrollView()
    private let tableView = UITableView()
    private let trackersName = CustomTextField()
    private let errorLabel = UILabel()
    private let saveButton = UIButton()
    private var newTrackersName: String?
    private let tableHeaders = ["Категория", "Расписание"]
    private var schedule = Set<WeekDay>()
    private var emoji: String?
    private var color: UIColor?
    private let emojies = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                           "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                           "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private let colors: [UIColor] = [.selection1, .selection2, .selection3, .selection4, .selection5, .selection6,
                                     .selection7, .selection8, .selection9, .selection10, .selection11, .selection12,
                                     .selection13, .selection14, .selection15, .selection16, .selection17, .selection18]
    
    private var tableViewTopConstraint: NSLayoutConstraint?
    var delegate: EditingViewControllerDelegate?
    private let uiColorMarshalling = UIColorMarshalling()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        newTrackersName = trackerToEdit?.name
        schedule = trackerToEdit?.schedule ?? Set()
        emoji = trackerToEdit?.emogi
        color = trackerToEdit?.color
        configureView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiCollectionView.allowsMultipleSelection = false
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        colorCollectionView.allowsMultipleSelection = false
    }
    
    private func configureView() {
        let label = UILabel()
        label.text = "Редактирование привычки"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 953)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 63),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let recordLabel = UILabel()
        recordLabel.text = String.getDay(count: UInt(trackerRecord ?? 0))
        recordLabel.textColor = .ypBlack
        recordLabel.font = .boldSystemFont(ofSize: 32)
        scrollView.addSubview(recordLabel)
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24)
        ])
        
        trackersName.placeholder = "Введите название трекера"
        trackersName.text = newTrackersName
        trackersName.textColor = .ypBlack
        trackersName.font = .systemFont(ofSize: 17)
        trackersName.backgroundColor = .background
        trackersName.layer.cornerRadius = 16
        trackersName.clearButtonMode = .whileEditing
        trackersName.returnKeyType = .go
        trackersName.delegate = self
        trackersName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        scrollView.addSubview(trackersName)
        trackersName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackersName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersName.heightAnchor.constraint(equalToConstant: 75),
            trackersName.topAnchor.constraint(equalTo: recordLabel.bottomAnchor, constant: 40)
        ])
        
        errorLabel.text = "Ограничение 38 символов"
        errorLabel.font = .systemFont(ofSize: 17)
        errorLabel.textColor = .ypRed
        
        scrollView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: trackersName.bottomAnchor, constant: 8)
        ])
        
        errorLabel.isHidden = true
        
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        tableView.separatorColor = .ypGray
        scrollView.addSubview(tableView)
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
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let emojiLabel = UILabel()
        emojiLabel.text = "Emoji"
        emojiLabel.textColor = .ypBlack
        emojiLabel.font = .boldSystemFont(ofSize: 19)
        scrollView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            emojiLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32)
        ])
        
        emojiCollectionView.backgroundColor = .ypWhite
        scrollView.addSubview(emojiCollectionView)
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
            emojiCollectionView.bottomAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 180)
        ])
        
        let colorLabel = UILabel()
        colorLabel.text = "Цвет"
        colorLabel.textColor = .ypBlack
        colorLabel.font = .boldSystemFont(ofSize: 19)
        scrollView.addSubview(colorLabel)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40)
        ])
        
        colorCollectionView.backgroundColor = .ypWhite
        scrollView.addSubview(colorCollectionView)
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
            colorCollectionView.bottomAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 180)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 40),
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
        
        saveButton.setImage(UIImage(named: "SaveButton"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonDidTap(_:)), for: .touchUpInside)
        saveButton.isEnabled = false
        stackView.addArrangedSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
    
    private func enableCreateButtonIfNeeded() {
        if errorLabel.isHidden == true,
           category?.isEmpty == false,
           newTrackersName?.isEmpty == false,
           emoji?.isEmpty == false,
           schedule.isEmpty == false,
           color != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @objc private func cancelButtonDidTap(_ sender: Any?) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonDidTap(_ sender: Any?) {
        let updatedTracker = Tracker(
            id: trackerToEdit?.id ?? UUID(),
            name: newTrackersName ?? "",
            color: color ?? UIColor(),
            emogi: emoji ?? "",
            pinned: trackerToEdit?.pinned ?? false,
            schedule: schedule)
        delegate?.updateTracker(tracker: updatedTracker, header: category ?? "")
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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

//MARK: - UICollectionViewDataSource
extension TrackerEditingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell else { return UICollectionViewCell()}
            
            cell.emoji.text = emojies[indexPath.row]
            
            if cell.emoji.text == emoji {
                cell.contentView.backgroundColor = .ypLightGray
            } else {
                cell.contentView.backgroundColor = .white
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell else { return UICollectionViewCell()}
            
            cell.colorView.backgroundColor = colors[indexPath.row]

            let cellColor = uiColorMarshalling.hexString(from: cell.colorView.backgroundColor ?? UIColor())
            let trackerColor = uiColorMarshalling.hexString(from: color ?? UIColor())
            
            if cellColor == trackerColor {
                cell.backgroundColorView.layer.borderColor = color?.withAlphaComponent(0.3).cgColor
            } else {
                cell.backgroundColorView.layer.borderColor = UIColor.white.cgColor
            }
            
            
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackerEditingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

//MARK: - UICollectionViewDelegate
extension TrackerEditingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = emojiCollectionView.cellForItem(at: indexPath) as? EmojiCell
            emoji = cell?.emoji.text
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        } else {
            let cell = colorCollectionView.cellForItem(at: indexPath) as? ColorCell
            color = cell?.colorView.backgroundColor
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        }
        enableCreateButtonIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = emojiCollectionView.cellForItem(at: indexPath) as? EmojiCell
            cell?.contentView.backgroundColor = .white
        } else {
            let cell = colorCollectionView.cellForItem(at: indexPath) as? ColorCell
            cell?.backgroundColorView.layer.borderColor = UIColor.white.cgColor
        }
    }
}


//MARK: - UITableViewDataSource
extension TrackerEditingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableHeaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        cell.header.text = tableHeaders[indexPath.row]
        
        if indexPath.row == tableHeaders.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
            let scheduleString = WeekDay.monday.makeString(schedule)
            cell.addSecondLabel(chosen: scheduleString)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.addSecondLabel(chosen: category ?? "")
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TrackerEditingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let VC = CategoryViewController()
            VC.delegate = self
            VC.modalTransitionStyle = .flipHorizontal
            present(VC, animated: true)
        } else {
            let VC = ScheduleViewController()
            VC.delegate = self
            VC.modalTransitionStyle = .flipHorizontal
            present(VC, animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate
extension TrackerEditingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackersName.resignFirstResponder()
        
        if let text = trackersName.text {
            newTrackersName = text
        }
        enableCreateButtonIfNeeded()
        return true
    }
}

//MARK: - CategoryViewControllerDelegate
extension TrackerEditingViewController: CategoryViewControllerDelegate {
    func addCategory(chosenCategory: String) {
        self.category = chosenCategory
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CustomTableViewCell else { return }
        cell.addSecondLabel(chosen: category ?? "")
        
        enableCreateButtonIfNeeded()
    }
}

//MARK: - ScheduleViewControllerDelegate
extension TrackerEditingViewController: ScheduleViewControllerDelegate {
    func addSchedule(chosenSchedule: Set<WeekDay>) {
        self.schedule = chosenSchedule
        let scheduleString = WeekDay.monday.makeString(chosenSchedule)
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? CustomTableViewCell else { return }
        cell.addSecondLabel(chosen: scheduleString)
        
        enableCreateButtonIfNeeded()
    }
}
