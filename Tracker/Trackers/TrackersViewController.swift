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
    private var categories: [TrackerCategory] = []
    //mock:
    /*private var categories = [
        TrackerCategory(header: "Важное",
                        trackers: [Tracker(id: UUID(), name: "Зарядка", color: .selection5, emogi: "⚽️", schedule: [.monday, .tuesday, .friday]),
                                   Tracker(id: UUID(), name: "Пить достаточно воды", color: .selection1, emogi: "💧", schedule: [.monday, .sunday]),
                                   Tracker(id: UUID(), name: "Не пить алкоголь", color: .selection15, emogi: "🍸", schedule: [.saturday, .tuesday])]),
        TrackerCategory(header: "Домашний уют",
                        trackers: [Tracker(id: UUID(), name: "Поливать цветы", color: .selection2, emogi: "🌺", schedule: [.wednesday]),
                                   Tracker(id: UUID(), name: "Пылесосить", color: .selection12, emogi: "🥵", schedule: [.sunday])]),
        TrackerCategory(header: "Радостные мелочи",
                        trackers: [Tracker(id: UUID(), name: "Смешная фотография кошки", color: .selection3, emogi: "😻", schedule: nil)])]*/
    
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
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
            categories = [TrackerCategory(header: trackerCategoryStore.categories[0], trackers: trackerStore.trackers)]
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
        let label = UILabel()
        label.text = "Трекеры"
        label.font = .boldSystemFont(ofSize: 34)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 96)
        ])
        
        searchTextField.placeholder = "Поиск"
        searchTextField.textColor = .ypBlack
        searchTextField.backgroundColor = .searchBarColor
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
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: label.centerYAnchor)
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
        
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        view.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8)
        ])
    }
    
    private func reloadPlaceholder() {
        placeholder.isHidden = !categories.isEmpty
        placeholder.isHidden = !visibleCategories.isEmpty
        placeholderLabel.isHidden = !categories.isEmpty
        placeholderLabel.isHidden = !visibleCategories.isEmpty
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
        cell.emoji.text = currentTracker.emogi
        cell.trackerName.text = currentTracker.name
        cell.trackerId = currentTracker.id
        cell.indexPath = indexPath
        cell.isCompletedToday = isTrackerCompletedToday(id: currentTracker.id)
        
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
        let dayText = String.getDayAddition(int: cell.completedDays ?? 0)
        
        cell.day.text = "\(cell.completedDays ?? 0) \(dayText)"
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

//MARK: - TrackersCellDelegate
extension TrackersViewController: TrackersCellDelegate {
    func markTrackerAsDone(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        try! trackerRecordStore.addNewTrackerRecord(trackerRecord)
    }
    
    func unmarkTrackerAsDone(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        try! trackerRecordStore.removeRecord(trackerRecord)
    }
}

//MARK: - CreationViewControllerDelegate
extension TrackersViewController: CreationViewControllerDelegate {
    func addNewTracker(tracker: Tracker, header: String) {
        try! trackerCategoryStore.addNewCategory(header)
        try! trackerStore.addNewTracker(tracker)
    }
}

//MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
     
        categories = [TrackerCategory(header: trackerCategoryStore.categories.first ?? "Важное", trackers: trackerStore.trackers)]
        
        visibleCategories = categories
        
        collectionView.performBatchUpdates {
            if collectionView.numberOfSections == 0 {
                collectionView.insertSections(IndexSet(integer: 0))
                collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
            } else {
                let insertedIndexPaths = update.insertedIndexes.map { IndexPath(item: $0, section: 0) }
                let deletedIndexPaths = update.deletedIndexes.map { IndexPath(item: $0, section: 0) }
                let updatedIndexPaths = update.updatedIndexes.map { IndexPath(item: $0, section: 0) }
                collectionView.insertItems(at: insertedIndexPaths)
                collectionView.insertItems(at: deletedIndexPaths)
                collectionView.insertItems(at: updatedIndexPaths)
                for move in update.movedIndexes {
                    collectionView.moveItem(
                        at: IndexPath(item: move.oldIndex, section: 0),
                        to: IndexPath(item: move.newIndex, section: 0)
                    )
                }
            }
        }
        
        reloadVisibleCategories()
        reloadPlaceholder()
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension TrackersViewController: TrackerCategoryStoreDelegate {
    func storeCategory(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        // to be done
    }
}

//MARK: - TrackerStoreDelegate
extension TrackersViewController : TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore) {
        completedTrackers = trackerRecordStore.trackersRecords
        
        let visibleTrackers = visibleCategories[0].trackers.count
        var visiblePaths = [IndexPath]()
        
        for i in 0..<visibleTrackers {
            visiblePaths.append(IndexPath(row: i, section: 0))
        }
        
        collectionView.reloadItems(at: visiblePaths)
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
