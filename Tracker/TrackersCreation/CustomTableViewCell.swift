//
//  CustomTableViewCell.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 04.06.2023.
//

import Foundation
import UIKit

final class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    let stackView = UIStackView()
    let header = UILabel()
    let text = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let view = UIView(frame: contentView.frame)
        view.backgroundColor = .backgroundDay
        backgroundView = view
        accessoryType = .disclosureIndicator
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 56)
        ])
        
        header.textColor = .ypBlack
        header.font = .systemFont(ofSize: 17)
        stackView.addArrangedSubview(header)
    }
    
    func addSecondLabel(chosen: String) {
        text.textColor = .ypGray
        text.font = .systemFont(ofSize: 17)
        text.text = chosen
        stackView.addArrangedSubview(text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
