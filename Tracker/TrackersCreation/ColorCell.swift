//
//  ColorCell.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 16.06.2023.
//

import Foundation
import UIKit

final class ColorCell: UICollectionViewCell {
    
    let backgroundColorView = UIView()
    let colorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        colorView.layer.cornerRadius = 8
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        backgroundColorView.frame = colorView.frame.insetBy(dx: -6, dy: -6)
        backgroundColorView.layer.cornerRadius = 8
        backgroundColorView.layer.borderWidth = 3
        backgroundColorView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(backgroundColorView)
        backgroundColorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundColorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backgroundColorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backgroundColorView.heightAnchor.constraint(equalToConstant: 52),
            backgroundColorView.widthAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
