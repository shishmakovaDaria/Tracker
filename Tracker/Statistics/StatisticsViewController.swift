//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 11.05.2023.
//

import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
    private let placeholder = UIImageView()
    private let placeholderLabel = UILabel()
    private let countLabel = UILabel()
    private let statisticsView = UIView()
    private let trackerRecordStore = TrackerRecordStore()
    private let uiColorMarshalling = UIColorMarshalling()
    private var completedTrackers = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completedTrackers = trackerRecordStore.trackersRecords.count
        setUpUI()
        reloadPlaceholder()
        trackerRecordStore.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpGradient()
    }

    private func setUpUI() {
        view.backgroundColor = .ypWhite
        
        let label = UILabel()
        label.text = "Statistics".localized()
        label.font = .boldSystemFont(ofSize: 34)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 96)
        ])
        
        placeholder.image = UIImage(named: "Emoji")
        placeholder.clipsToBounds = true
        view.addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.topAnchor.constraint(equalTo: view.topAnchor, constant: 375),
            placeholder.heightAnchor.constraint(equalToConstant: 80),
            placeholder.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        placeholderLabel.text = "Nothing to analyze yet".localized()
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        view.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8)
        ])
        
        statisticsView.layer.borderWidth = 1
        statisticsView.layer.cornerRadius = 16
        view.addSubview(statisticsView)
        statisticsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statisticsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            statisticsView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        countLabel.text = "\(completedTrackers)"
        countLabel.font = .boldSystemFont(ofSize: 34)
        statisticsView.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: statisticsView.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: statisticsView.topAnchor, constant: 12)
        ])
        
        let statisticsLabel = UILabel()
        statisticsLabel.text = "Трекеров завершено"
        statisticsLabel.font = .systemFont(ofSize: 12, weight: .medium)
        statisticsView.addSubview(statisticsLabel)
        statisticsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statisticsLabel.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor),
            statisticsLabel.topAnchor.constraint(equalTo: statisticsView.topAnchor, constant: 60)
        ])
    }
    
    private func setUpGradient() {
        let gradient = UIImage.gradientImage(bounds: statisticsView.bounds, colors: [
            uiColorMarshalling.color(from: "FD4C49"),
            uiColorMarshalling.color(from: "46E69D"),
            uiColorMarshalling.color(from: "007BFA")
        ])
        let gradientColor = UIColor(patternImage: gradient).cgColor
        statisticsView.layer.borderColor = gradientColor
    }
    
    private func reloadPlaceholder() {
        if completedTrackers == 0 {
            placeholder.isHidden = false
            placeholderLabel.isHidden = false
            statisticsView.isHidden = true
        } else {
            placeholder.isHidden = true
            placeholderLabel.isHidden = true
            statisticsView.isHidden = false
        }
    }
}

//MARK: - TrackerRecordStoreDelegate
extension StatisticsViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore) {
        completedTrackers = trackerRecordStore.trackersRecords.count
        reloadPlaceholder()
        countLabel.text = "\(completedTrackers)"
    }
}
