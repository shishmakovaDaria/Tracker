//
//  EmojiCell.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 16.06.2023.
//

import Foundation
import UIKit

final class EmojiCell: UICollectionViewCell {
    lazy var emoji: UILabel = {
        let emoji = UILabel()
        emoji.font = .systemFont(ofSize: 32)
        return emoji
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUIAndConstraints() {
        contentView.layer.cornerRadius = 16
        contentView.addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
