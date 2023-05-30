//
//  ViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 24.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let color: [UIColor] = [ .selection5, .selection2]
    //let color: [UIColor] = []
    let emoji = [ "🍇", "🍈"]
    let trackers = ["Зарядка", "Вода"]
    let day = ["1 день", "2 дня"]
    let groups = ["Домашний уют", "Радостные мелочи"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackersCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            TrackersHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
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
    }
    
    @IBAction private func plusButtonDidTap(_ sender: Any?) {
        // to be done
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
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if color.count > 0 {
            self.collectionView.backgroundView = nil
            return color.count
        } else {
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
            
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath) as? TrackersCell else { return UICollectionViewCell()}
        
        cell.colorView.backgroundColor = color[indexPath.row]
        cell.colorRound.backgroundColor = color[indexPath.row]
        cell.emoji.text = emoji[indexPath.row]
        cell.trackerName.text = trackers[indexPath.row]
        cell.day.text = day[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackersHeaders else { return UICollectionReusableView() }
        
        view.titleLabel.text = groups[indexPath.row]
        view.titleLabel.font = .boldSystemFont(ofSize: 19)
        return view
    }
}

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
}
