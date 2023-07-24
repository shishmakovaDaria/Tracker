//
//  TrackersCell.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 12.05.2023.
//

import Foundation
import UIKit

protocol TrackersCellDelegate: AnyObject {
    func markTrackerAsDone(id: UUID, at indexPath: IndexPath)
    func unmarkTrackerAsDone(id: UUID, at indexPath: IndexPath)
}

final class TrackersCell: UICollectionViewCell {
    
    weak var delegate: TrackersCellDelegate?
    var isCompletedToday: Bool = false
    var trackerId: UUID?
    var indexPath: IndexPath?
    var completedDays: Int?
    var pinned: Bool = false
    
    let colorView = UIView()
    let trackerName = UILabel()
    let emoji = UILabel()
    let whiteRound = UIView()
    let day = UILabel()
    let button = UIButton()
    let done = UIImageView()
    let pin = UIImageView()
    
    private let analyticsService = AnalyticsService()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupPin() {
        if pinned == false {
            pin.isHidden = true
        } else {
            pin.isHidden = false
        }
    }
    
    private func setupViews() {
        colorView.layer.cornerRadius = 16
        colorView.layer.masksToBounds = true
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        trackerName.font = .systemFont(ofSize: 12)
        trackerName.textColor = .white
        trackerName.numberOfLines = 2
        colorView.addSubview(trackerName)
        trackerName.translatesAutoresizingMaskIntoConstraints = false
        
        whiteRound.layer.cornerRadius = 12
        whiteRound.layer.masksToBounds = true
        whiteRound.backgroundColor = .white.withAlphaComponent(0.3)
        colorView.addSubview(whiteRound)
        whiteRound.translatesAutoresizingMaskIntoConstraints = false
        
        emoji.font = .systemFont(ofSize: 12)
        whiteRound.addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        day.font = .systemFont(ofSize: 12)
        day.textColor = .ypBlack
        contentView.addSubview(day)
        day.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(trackerButtonClicked(_:)), for: .touchUpInside)
        button.tintColor = .white
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        done.image = UIImage(named: "Done")
        button.addSubview(done)
        done.translatesAutoresizingMaskIntoConstraints = false
        
        pin.image = UIImage(named: "Pin")
        colorView.addSubview(pin)
        pin.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            trackerName.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            trackerName.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            trackerName.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            
            whiteRound.heightAnchor.constraint(equalToConstant: 24),
            whiteRound.widthAnchor.constraint(equalToConstant: 24),
            whiteRound.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            whiteRound.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            
            emoji.heightAnchor.constraint(equalToConstant: 22),
            emoji.widthAnchor.constraint(equalToConstant: 16),
            emoji.centerXAnchor.constraint(equalTo: whiteRound.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: whiteRound.centerYAnchor),
            
            day.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            day.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            day.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 34),
            button.widthAnchor.constraint(equalToConstant: 34),
            
            done.heightAnchor.constraint(equalToConstant: 12),
            done.widthAnchor.constraint(equalToConstant: 12),
            done.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            done.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            pin.centerYAnchor.constraint(equalTo: whiteRound.centerYAnchor),
            pin.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -4)
        ])
    }
    
    @objc private func trackerButtonClicked(_ sender: Any?) {
        analyticsService.didTapTrackerOnMain()
        guard let trackerId = trackerId, let indexPath = indexPath else { return }
        if isCompletedToday {
            delegate?.unmarkTrackerAsDone(id: trackerId, at: indexPath)
        } else {
            delegate?.markTrackerAsDone(id: trackerId, at: indexPath)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
