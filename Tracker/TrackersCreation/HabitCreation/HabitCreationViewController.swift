//
//  CreationViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 02.06.2023.
//

import Foundation
import UIKit

final class HabitCreationViewController: UIViewController {
    var viewModel: HabitCreationViewModel?
    private var tableViewTopConstraint: NSLayoutConstraint?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.width, height: 875)
        return scrollView
    }()
    
    private lazy var trackersName: CustomTextField = {
        let trackersName = CustomTextField()
        trackersName.placeholder = "Введите название трекера"
        trackersName.textColor = .ypBlack
        trackersName.font = .systemFont(ofSize: 17)
        trackersName.backgroundColor = .background
        trackersName.layer.cornerRadius = 16
        trackersName.clearButtonMode = .whileEditing
        trackersName.returnKeyType = .go
        trackersName.delegate = self
        trackersName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return trackersName
    }()
    
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.text = "Ограничение 38 символов"
        errorLabel.font = .systemFont(ofSize: 17)
        errorLabel.textColor = .ypRed
        errorLabel.isHidden = true
        return errorLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        tableView.separatorColor = .ypGray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.text = "Emoji"
        emojiLabel.textColor = .ypBlack
        emojiLabel.font = .boldSystemFont(ofSize: 19)
        return emojiLabel
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let emojiCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        emojiCollectionView.backgroundColor = .ypWhite
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiCollectionView.allowsMultipleSelection = false
        return emojiCollectionView
    }()
    
    private lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.text = "Цвет"
        colorLabel.textColor = .ypBlack
        colorLabel.font = .boldSystemFont(ofSize: 19)
        return colorLabel
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let colorCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        colorCollectionView.backgroundColor = .ypWhite
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        colorCollectionView.allowsMultipleSelection = false
        return colorCollectionView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "CancelButton"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap(_:)), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.setImage(UIImage(named: "CreateButtonBlack"), for: .normal)
        createButton.setImage(UIImage(named: "CreateButtonGray"), for: .disabled)
        createButton.addTarget(self, action: #selector(createButtonDidTap(_:)), for: .touchUpInside)
        createButton.isEnabled = false
        return createButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bind()
    }
    
    @objc private func cancelButtonDidTap(_ sender: Any?) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonDidTap(_ sender: Any?) {
        viewModel?.createTracker()
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
    
    private func bind() {
        viewModel?.$trackersName.bind { [weak self] _ in
            self?.enableCreateButtonIfNeeded()
        }
        
        viewModel?.$trackersSchedule.bind { [weak self] _ in
            self?.enableCreateButtonIfNeeded()
        }
        
        viewModel?.$trackersEmoji.bind { [weak self] _ in
            self?.enableCreateButtonIfNeeded()
        }
        
        viewModel?.$trackersColor.bind { [weak self] _ in
            self?.enableCreateButtonIfNeeded()
        }
        
        viewModel?.$trackersCategory.bind { [weak self] _ in
            self?.enableCreateButtonIfNeeded()
        }
    }
    
    private func enableCreateButtonIfNeeded() {
        if errorLabel.isHidden == true,
           viewModel?.allParametersChosen() == true {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [label, scrollView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [trackersName, errorLabel, tableView, emojiLabel, emojiCollectionView, colorLabel, colorCollectionView, stackView].forEach {
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [cancelButton, createButton].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
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
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 63),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            trackersName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersName.heightAnchor.constraint(equalToConstant: 75),
            trackersName.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: trackersName.bottomAnchor, constant: 8),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewTopConstraint,
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            emojiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            emojiLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
            emojiCollectionView.bottomAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 180),
            
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
            
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
            colorCollectionView.bottomAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 180),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 40),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension HabitCreationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell else { return UICollectionViewCell()}
            
            cell.emoji.text = Constants.emojies[indexPath.row]
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell else { return UICollectionViewCell()}
            
            cell.colorView.backgroundColor = Constants.colors[indexPath.row]
            
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HabitCreationViewController: UICollectionViewDelegateFlowLayout {
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
extension HabitCreationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = emojiCollectionView.cellForItem(at: indexPath) as? EmojiCell
            cell?.contentView.backgroundColor = .ypLightGray
            viewModel?.emojiChosen(emoji: cell?.emoji.text ?? "")
        } else {
            let cell = colorCollectionView.cellForItem(at: indexPath) as? ColorCell
            let currentColor = cell?.colorView.backgroundColor
            cell?.backgroundColorView.layer.borderColor = currentColor?.withAlphaComponent(0.3).cgColor
            viewModel?.colorChosen(color: cell?.colorView.backgroundColor ?? UIColor.clear)
        }
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
extension HabitCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.tableHeaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        cell.header.text = Constants.tableHeaders[indexPath.row]
        
        if indexPath.row == Constants.tableHeaders.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        if viewModel?.trackersCategory != "" {
            cell.addSecondLabel(chosen: viewModel?.trackersCategory ?? "")
            tableView.reloadData()
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension HabitCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = CategoryViewController()
            vc.viewModel = CategoryViewModel()
            vc.viewModel?.currentCategory = viewModel?.trackersCategory ?? ""
            vc.delegate = self
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true)
        } else {
            let vc = ScheduleViewController()
            vc.viewModel = ScheduleViewModel()
            vc.viewModel?.schedule = viewModel?.trackersSchedule ?? Set<WeekDay>()
            vc.viewModel?.delegate = self
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate
extension HabitCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackersName.resignFirstResponder()
        
        if let text = trackersName.text {
            viewModel?.trackerNameCreated(name: text)
        }
        
        return true
    }
}

//MARK: - CategoryViewControllerDelegate
extension HabitCreationViewController: CategoryViewControllerDelegate {
    func addCategory(chosenCategory: String) {
        viewModel?.categoryChosen(category: chosenCategory)
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CustomTableViewCell else { return }
        cell.addSecondLabel(chosen: viewModel?.trackersCategory ?? "")
    }
}

//MARK: - ScheduleViewControllerDelegate
extension HabitCreationViewController: ScheduleViewControllerDelegate {
    func addSchedule(chosenSchedule: Set<WeekDay>) {
        viewModel?.scheduleCreated(schedule: chosenSchedule)
        let scheduleString = WeekDay.monday.makeString(chosenSchedule)
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? CustomTableViewCell else { return }
        cell.addSecondLabel(chosen: scheduleString)
    }
}
