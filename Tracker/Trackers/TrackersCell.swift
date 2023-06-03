//
//  TrackersCell.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 12.05.2023.
//

import Foundation
import UIKit

protocol TrackersCellDelegate: AnyObject {
    func trackersButtonDidTap(_ cell: TrackersCell)
}

final class TrackersCell: UICollectionViewCell {
    
    weak var delegate: TrackersCellDelegate?
    
    let colorView = UIView()
    let trackerName = UILabel()
    let emoji = UILabel()
    let whiteRound = UIView()
    let day = UILabel()
    let colorRound = UIView()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorView.layer.cornerRadius = 16
        colorView.layer.masksToBounds = true
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        trackerName.font = .systemFont(ofSize: 12)
        trackerName.textColor = .white
        colorView.addSubview(trackerName)
        trackerName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackerName.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            trackerName.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            trackerName.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12)
        ])
        
        whiteRound.layer.cornerRadius = 12
        whiteRound.layer.masksToBounds = true
        whiteRound.backgroundColor = .white.withAlphaComponent(0.3)
        colorView.addSubview(whiteRound)
        whiteRound.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            whiteRound.heightAnchor.constraint(equalToConstant: 24),
            whiteRound.widthAnchor.constraint(equalToConstant: 24),
            whiteRound.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            whiteRound.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12)
        ])

        emoji.font = .systemFont(ofSize: 12)
        whiteRound.addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.heightAnchor.constraint(equalToConstant: 22),
            emoji.widthAnchor.constraint(equalToConstant: 16),
            emoji.centerXAnchor.constraint(equalTo: whiteRound.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: whiteRound.centerYAnchor)
        ])
        
        day.font = .systemFont(ofSize: 12)
        day.textColor = .ypBlack
        contentView.addSubview(day)
        day.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            day.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            day.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            day.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        colorRound.layer.cornerRadius = 17
        colorRound.layer.masksToBounds = true
        contentView.addSubview(colorRound)
        colorRound.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorRound.heightAnchor.constraint(equalToConstant: 34),
            colorRound.widthAnchor.constraint(equalToConstant: 34),
            colorRound.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            colorRound.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        let button = UIButton.systemButton(with: UIImage(named: "Plus")!,
                                           target: self,
                                           action: nil)
        button.addTarget(self, action: #selector(trackerButtonClicked(_:)), for: .touchUpInside)
        button.tintColor = .white
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 10.21),
            button.widthAnchor.constraint(equalToConstant: 10.63),
            button.centerXAnchor.constraint(equalTo: colorRound.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: colorRound.centerYAnchor)
        ])
    }
    
    func markTrackerAsDone(isDone: Bool) {
        if isDone {
            button.imageView?.image = UIImage(named: "Done")
            //colorRound.backgroundColor?.withAlphaComponent(0.3)
        } else {
            button.imageView?.image = UIImage(named: "Plus")
            //colorRound.backgroundColor?.withAlphaComponent(1)
        }
    }
    
    @IBAction private func trackerButtonClicked(_ sender: Any?) {
        delegate?.trackersButtonDidTap(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
