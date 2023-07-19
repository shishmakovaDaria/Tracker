//
//  ViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 24.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let placeholder = UIImageView()
    private let placeholderLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let searchTextField = UISearchTextField()
    private let filterButton = UIButton()
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        addCollectionView()
        addViews()
        trackerStore.delegate = self
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackersCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            TrackersHeaders.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header")
        if trackerCategoryStore.categories != [] {
            categories = updateCategoriesFromStore()
        }
        completedTrackers = trackerRecordStore.trackersRecords
        reloadVisibleCategories()
        reloadPlaceholder()
    }
    
    func showTrackersCreationViewController() {
        let VC = TrackersCreationViewController()
        VC.controller = self
        present(VC, animated: true)
    }
    
    private func addCollectionView() {
        collectionView.backgroundColor = .ypWhite
        collectionView.allowsMultipleSelection = false
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addViews() {
        view.backgroundColor = .ypWhite
        
        let label = UILabel()
        label.text = "Trackers".localized()
        label.font = .boldSystemFont(ofSize: 34)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 96)
        ])
        
        searchTextField.placeholder = "Search".localized()
        searchTextField.textColor = .ypBlack
        searchTextField.delegate = self
        searchTextField.returnKeyType = .go
        searchTextField.addTarget(self, action: #selector(searchTextFieldChanged), for: .editingChanged)
        view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            searchTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.calendar.firstWeekday = 2
        datePicker.locale = .current
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        placeholder.image = UIImage(named: "Star")
        placeholder.clipsToBounds = true
        view.addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            placeholder.heightAnchor.constraint(equalToConstant: 80),
            placeholder.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        placeholderLabel.text = "What will we track?".localized()
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        view.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8)
        ])
        
        filterButton.setTitle("Filters".localized(), for: .normal)
        filterButton.backgroundColor = .ypBlue
        filterButton.layer.cornerRadius = 16
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    private func reloadPlaceholder() {
        placeholder.isHidden = !categories.isEmpty
        placeholder.isHidden = !visibleCategories.isEmpty
        placeholderLabel.isHidden = !categories.isEmpty
        placeholderLabel.isHidden = !visibleCategories.isEmpty
        filterButton.isHidden = categories.isEmpty
        filterButton.isHidden = visibleCategories.isEmpty
    }
    
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        let filterWeekdayEnumCase = WeekDay.monday.makeWeekDay(filterWeekday: filterWeekday)
        let filterText = (searchTextField.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                                    tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay == filterWeekdayEnumCase
                } == true
                
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                header: category.header,
                trackers: trackers
            )
        }
        
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
    }
    
    private func updateCategoriesFromStore() -> [TrackerCategory] {
        var allCategories: [TrackerCategory] = []
        
        let pinnedTrackers = trackerStore.trackers.filter { tracker in
            return tracker.pinned == true
        }
        
        if pinnedTrackers.count != 0 {
            allCategories.append(TrackerCategory(
                header: "Закрепленные",
                trackers: pinnedTrackers))
        }
        
        let otherCategories = trackerCategoryStore.categories.map { category in
            let trackersInCurrentCategory = trackerStore.trackersForCurrentCategory(currentCategory: category)
            
            return TrackerCategory(header: category,
                                   trackers: trackersInCurrentCategory)
        }
        for category in otherCategories {
            allCategories.append(category)
        }
        
        return allCategories
    }
    
    private func fixTracker(_ trackerId: UUID, cell: TrackersCell) {
        if cell.pinned == false {
            cell.pinned = true
        } else {
            cell.pinned = false
        }
        cell.setupPin()
        try? trackerStore.updatePin(trackerId, currentPinned: cell.pinned)
    }
    
    private func editTracker(_ trackerId: UUID) {
        let VC = TrackerEditingViewController()
        VC.delegate = self
        let trackerToEdit = trackerStore.trackers.filter { tracker in
            return tracker.id == trackerId
        }
        VC.trackerToEdit = trackerToEdit[0]
        VC.category = trackerStore.currentCategory(trackerId)
        let trackerRecord = completedTrackers.filter { record in
            return record.id == trackerId
        }
        VC.trackerRecord = trackerRecord.count
        present(VC, animated: true)
    }
    
    private func deleteTracker(_ trackerId: UUID) {
        let alert = UIAlertController(title: "Уверены, что хотите удалить трекер?",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            try? self.trackerRecordStore.removeAllRecordsOfTracker(trackerId)
            try? self.trackerStore.deleteTracker(trackerId)
        }
        
        let action2 = UIAlertAction(title: "Отменить", style: .cancel) {_ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)

        self.present(alert, animated: true)
    }
    
    @objc private func dateChanged() {
        reloadVisibleCategories()
    }
    
    @objc private func searchTextFieldChanged() {
        reloadVisibleCategories()
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath) as? TrackersCell else { return UICollectionViewCell()}
        
        let currentTracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        cell.colorView.backgroundColor = currentTracker.color
        cell.emoji.text = currentTracker.emoji
        cell.trackerName.text = currentTracker.name
        cell.trackerId = currentTracker.id
        cell.indexPath = indexPath
        cell.isCompletedToday = isTrackerCompletedToday(id: currentTracker.id)
        cell.pinned = currentTracker.pinned
        cell.setupPin()
        
        if cell.isCompletedToday {
            let buttonImage = UIImage(named: "DoneButton")?.withTintColor(currentTracker.color)
            cell.button.setImage(buttonImage, for: .normal)
            cell.done.isHidden = false
        } else {
            let buttonImage = UIImage(named: "AddButton")?.withTintColor(currentTracker.color)
            cell.done.isHidden = true
            cell.button.setImage(buttonImage, for: .normal)
        }
        
        cell.completedDays = completedTrackers.filter { $0.id == currentTracker.id}.count
        cell.day.text = String.getDay(count: UInt(cell.completedDays ?? 0))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackersHeaders else { return UICollectionReusableView() }
        
        if visibleCategories.count == 0 {
            return UICollectionReusableView()
        } else {
            view.titleLabel.text = visibleCategories[indexPath.section].header
            view.titleLabel.font = .boldSystemFont(ofSize: 19)
            return view
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 10) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: (collectionView.frame.width - 56),
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}

//MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil }
        let indexPath = indexPaths[0]
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCell else { return nil }
        guard let trackerId = cell.trackerId else { return nil }
        
        var firstActionName: String {
            if cell.pinned == false {
                return "Закрепить"
            } else {
                return "Открепить"
            }
        }
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "\(firstActionName)") { [weak self] _ in
                    self?.fixTracker(trackerId, cell: cell)
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.editTracker(trackerId)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.deleteTracker(trackerId)
                },
            ])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCell else { return nil }
        return UITargetedPreview(view: cell.colorView)
    }
}

//MARK: - TrackersCellDelegate
extension TrackersViewController: TrackersCellDelegate {
    func markTrackerAsDone(id: UUID, at indexPath: IndexPath) {
        let currentDate = Date()
        if Calendar.current.isDate(currentDate, inSameDayAs: datePicker.date) || datePicker.date < currentDate  {
            let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
            try! trackerRecordStore.addNewTrackerRecord(trackerRecord)
        } else {
            return
        }
    }
    
    func unmarkTrackerAsDone(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        try! trackerRecordStore.removeRecord(trackerRecord)
    }
}

//MARK: - CreationViewControllerDelegate
extension TrackersViewController: CreationViewControllerDelegate {
    func addNewTracker(tracker: Tracker, header: String) {
        try! trackerStore.addNewTracker(tracker, currentCategory: header)
    }
}

//MARK: - EditingViewControllerDelegate
extension TrackersViewController: EditingViewControllerDelegate {
    func updateTracker(tracker: Tracker, header: String) {
        try? trackerStore.updateTracker(tracker, currentCategory: header)
    }
}

//MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore) {
        categories = updateCategoriesFromStore()
        visibleCategories = categories
        collectionView.reloadData()
        reloadVisibleCategories()
        reloadPlaceholder()
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension TrackersViewController: TrackerCategoryStoreDelegate {
    func storeCategory(_ store: TrackerCategoryStore) {
        categories = updateCategoriesFromStore()
    }
}

//MARK: - TrackerRecordStoreDelegate
extension TrackersViewController : TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore) {
        completedTrackers = trackerRecordStore.trackersRecords
    }
}


//MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories()
        
        return true
    }
}
