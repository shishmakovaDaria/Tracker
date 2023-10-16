//
//  TrackersCell.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 12.05.2023.
//

import Foundation
import UIKit

struct TrackersCellModel {
    let name: String
    let color: UIColor
    let emoji: String
    let isCompletedToday: Bool
    let completedDays: Int
    let pinned: Bool
}

final class TrackersCell: UICollectionViewCell {
    lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 16
        colorView.layer.masksToBounds = true
        return colorView
    }()
    
    lazy var trackerName: UILabel = {
        let trackerName = UILabel()
        trackerName.font = .systemFont(ofSize: 12)
        trackerName.textColor = .white
        trackerName.numberOfLines = 2
        return trackerName
    }()
    
    lazy var emoji: UILabel = {
        let emoji = UILabel()
        emoji.font = .systemFont(ofSize: 12)
        return emoji
    }()
    
    lazy var day: UILabel = {
        let day = UILabel()
        day.font = .systemFont(ofSize: 12)
        day.textColor = .ypBlack
        return day
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(trackerButtonClicked(_:)), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var done: UIImageView = {
        let done = UIImageView()
        done.image = UIImage(named: "Done")
        return done
    }()
    
    private lazy var pin: UIImageView = {
        let pin = UIImageView()
        pin.image = UIImage(named: "Pin")
        return pin
    }()
    
    private lazy var whiteRound: UIView = {
        let whiteRound = UIView()
        whiteRound.layer.cornerRadius = 12
        whiteRound.layer.masksToBounds = true
        whiteRound.backgroundColor = .white.withAlphaComponent(0.3)
        return whiteRound
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var buttonTappedHandler: (() -> Void)?
       
    @objc private func trackerButtonClicked(_ sender: Any?) {
        buttonTappedHandler?()
    }
    
    func configureCell(cellModel: TrackersCellModel) {
        trackerName.text = cellModel.name
        colorView.backgroundColor = cellModel.color
        emoji.text = cellModel.emoji
        day.text = String.getDay(count: UInt(cellModel.completedDays))
        setupPin(pinned: cellModel.pinned)
        configureButton(cellModel: cellModel)
    }
    
    func setupPin(pinned: Bool) {
        if pinned == false {
            pin.isHidden = true
        } else {
            pin.isHidden = false
        }
    }
    
    private func configureButton(cellModel: TrackersCellModel) {
        if cellModel.isCompletedToday {
            let buttonImage = UIImage(named: "DoneButton")?.withTintColor(cellModel.color)
            button.setImage(buttonImage, for: .normal)
            done.isHidden = false
        } else {
            let buttonImage = UIImage(named: "AddButton")?.withTintColor(cellModel.color)
            done.isHidden = true
            button.setImage(buttonImage, for: .normal)
        }
    }
    
    private func setupUI() {
        [colorView, day, button].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [trackerName, whiteRound, pin].forEach {
            colorView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        whiteRound.addSubview(emoji)
        button.addSubview(done)
        
        [emoji, done].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
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
}
