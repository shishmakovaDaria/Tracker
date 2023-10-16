//
//  ColorCell.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 16.06.2023.
//

import Foundation
import UIKit

final class ColorCell: UICollectionViewCell {
    lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 8
        return colorView
    }()
    
    lazy var backgroundColorView: UIView = {
        let backgroundColorView = UIView()
        backgroundColorView.frame = colorView.frame.insetBy(dx: -6, dy: -6)
        backgroundColorView.layer.cornerRadius = 8
        backgroundColorView.layer.borderWidth = 3
        backgroundColorView.layer.borderColor = UIColor.ypWhite.cgColor
        return backgroundColorView
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        backgroundColorView.layer.borderColor = UIColor.ypWhite.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [colorView, backgroundColorView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            
            backgroundColorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backgroundColorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backgroundColorView.heightAnchor.constraint(equalToConstant: 52),
            backgroundColorView.widthAnchor.constraint(equalToConstant: 52)
        ])
    }
}
