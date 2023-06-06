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
    
    private var categories: [TrackerCategory] = []
    /*private var categories = [
        TrackerCategory(header: "Важное",
                        trackers: [Tracker(id: 1, name: "Зарядка", color: .selection5, emogi: "⚽️", schedule: "Пн"),
                                   Tracker(id: 2, name: "Пить достаточно воды", color: .selection1, emogi: "💧", schedule: "Вт"),
                                   Tracker(id: 3, name: "Не пить алкоголь", color: .selection15, emogi: "🍸", schedule: "Ср")]),
        TrackerCategory(header: "Домашний уют",
                        trackers: [Tracker(id: 4, name: "Поливать цветы", color: .selection2, emogi: "🌺", schedule: "Сб"),
                                   Tracker(id: 5, name: "Пылесосить", color: .selection12, emogi: "🥵", schedule: "Вс")]),
        TrackerCategory(header: "Радостные мелочи",
                        trackers: [Tracker(id: 6, name: "Смешная фотография кошки", color: .selection3, emogi: "😻", schedule: nil)])]*/
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    //private var currentDate: Date
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        addViews()
        addCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackersCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            TrackersHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        if categories.count == 0 {
            showPlaceholder()
        }
    }
    
    func showTrackersCreationViewController() {
        present(TrackersCreationViewController(), animated: true)
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
        
        let searchTextField = UISearchTextField()
        searchTextField.text = "Поиск"
        searchTextField.textColor = .ypGray
        searchTextField.backgroundColor = .searchBarColor
        view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            searchTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
    
    private func showPlaceholder() {
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
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8)
        ])
    }
    
    
    //можно удалить?
    func addNewTracker(newTracker: Tracker) {
        let num: Int
        var newTrackers: [Tracker]
        if categories.count == 0 {
            num = categories.count
            newTrackers = [newTracker]
        } else {
            num = categories[0].trackers.count
            newTrackers = categories[0].trackers
            newTrackers.append(newTracker)
        }
        

        let newCategories: [TrackerCategory] = [TrackerCategory(header: "Важное",
                                                                trackers: newTrackers)]
        self.categories = newCategories
        
        print(self.categories)
        print(categories.count)
        print(categories[0].trackers.count)
        
        
        
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [IndexPath(row: num, section: 0)])
        }
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath) as? TrackersCell else { return UICollectionViewCell()}
        
        cell.delegate = self
            cell.colorView.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color
            cell.colorRound.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color
            cell.emoji.text = categories[indexPath.section].trackers[indexPath.row].emogi
            cell.trackerName.text = categories[indexPath.section].trackers[indexPath.row].name
            cell.day.text = "0 дней"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackersHeaders else { return UICollectionReusableView() }
        
        if categories.count == 0 {
            return UICollectionReusableView()
        } else {
            view.titleLabel.text = categories[indexPath.section].header
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
    func trackersButtonDidTap(_ cell: TrackersCell) {
        //guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        cell.markTrackerAsDone(isDone: true)
    }
}

//MARK: - TrackersStorageDelegate
extension TrackersViewController: TrackersStorageDelegate {
    func dataUpdated() {
      
        //self.view.deletePlaceholder
       
        
        let newCategories = TrackersStorage.shared.categories
        
        self.categories = newCategories
        
        collectionView.performBatchUpdates {
            if collectionView.numberOfSections == 0 {
                collectionView.insertSections(IndexSet(integer: 0))
                collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
            } else {
                let num = categories[0].trackers.count
                collectionView.insertItems(at: [IndexPath(row: (num - 1), section: 0)])
            }
        }
    }
}
