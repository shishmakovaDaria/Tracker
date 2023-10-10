//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 11.05.2023.
//

import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
    var viewModel: StatisticsViewModel?
    private let uiColorMarshalling = UIColorMarshalling()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Statistics".localized()
        label.font = .boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var placeholder: UIImageView = {
        let placeholder = UIImageView()
        placeholder.image = UIImage(named: "Emoji")
        placeholder.clipsToBounds = true
        return placeholder
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Nothing to analyze yet".localized()
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return placeholderLabel
    }()
    
    private lazy var statisticsView: UIView = {
        let statisticsView = UIView()
        statisticsView.layer.borderWidth = 1
        statisticsView.layer.cornerRadius = 16
        return statisticsView
    }()
    
    private lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "\(viewModel?.completedTrackers ?? 0)"
        countLabel.font = .boldSystemFont(ofSize: 34)
        return countLabel
    }()
    
    private lazy var statisticsLabel: UILabel = {
        let statisticsLabel = UILabel()
        statisticsLabel.text = "Трекеров завершено"
        statisticsLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return statisticsLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        viewModel?.$completedTrackers.bind { [weak self] _ in
            self?.reloadPlaceholder()
            self?.countLabel.text = "\(self?.viewModel?.completedTrackers ?? 0)"
        }
        
        reloadPlaceholder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpGradient()
    }
    
    private func reloadPlaceholder() {
        if viewModel?.completedTrackers == 0 {
            placeholder.isHidden = false
            placeholderLabel.isHidden = false
            statisticsView.isHidden = true
        } else {
            placeholder.isHidden = true
            placeholderLabel.isHidden = true
            statisticsView.isHidden = false
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [label, placeholder, placeholderLabel, statisticsView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [countLabel, statisticsLabel].forEach {
            statisticsView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.topAnchor.constraint(equalTo: view.topAnchor, constant: 375),
            placeholder.heightAnchor.constraint(equalToConstant: 80),
            placeholder.widthAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8),
            
            statisticsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            statisticsView.heightAnchor.constraint(equalToConstant: 90),
            
            countLabel.leadingAnchor.constraint(equalTo: statisticsView.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: statisticsView.topAnchor, constant: 12),
            
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
}
