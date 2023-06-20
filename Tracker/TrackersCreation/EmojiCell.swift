//
//  EmojiCell.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 16.06.2023.
//

import Foundation
import UIKit

final class EmojiCell: UICollectionViewCell {
    
    let emoji = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 16
        emoji.font = .systemFont(ofSize: 32)
        contentView.addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
