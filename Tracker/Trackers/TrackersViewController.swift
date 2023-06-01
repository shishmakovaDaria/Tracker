//
//  ViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 24.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //var categories: [TrackerCategory] = []
    var categories = [TrackerCategory(header: "Здоровье",
                                      trackers: [Tracker(id: 1, name: "Зарядка", color: .selection5, emogi: "⚽️"),
                                                 Tracker(id: 2, name: "Пить достаточно воды", color: .selection1, emogi: "💧"),
                                                 Tracker(id: 3, name: "Не пить алкоголь", color: .selection15, emogi: "🍸")]),
                      TrackerCategory(header: "Домашний уют",
                                      trackers: [Tracker(id: 4, name: "Поливать цветы", color: .selection2, emogi: "🌺"),
                                                 Tracker(id: 5, name: "Пылесосить", color: .selection12, emogi: "🥵")]),
                      TrackerCategory(header: "Радостные мелочи",
                                      trackers: [Tracker(id: 6, name: "Смешная кошка", color: .selection3, emogi: "😻")])]
    
    var completedTrackers: [TrackerRecord] = []
    //var currentDate: Date
    
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
    
    private func showStartView() {
        let rect = CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height)
        let emptyView = UIView(frame: rect)
        self.collectionView.backgroundView = emptyView
        
        let star = UIImageView()
        star.image = UIImage(named: "Star")
        star.clipsToBounds = true
        emptyView.addSubview(star)
        star.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            star.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            star.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            star.heightAnchor.constraint(equalToConstant: 80),
            star.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12)
        emptyView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            label.topAnchor.constraint(equalTo: star.bottomAnchor, constant: 8)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if categories.count > 0 {
            self.collectionView.backgroundView = nil
            return categories.count
        } else {
            showStartView()
            return 0
        }
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
