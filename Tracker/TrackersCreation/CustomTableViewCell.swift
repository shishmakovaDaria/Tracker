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
    let header = UILabel()
    let text = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let view = UIView(frame: contentView.frame)
        view.backgroundColor = .backgroundDay
        backgroundView = view
        accessoryType = .disclosureIndicator
        
        header.textColor = .ypBlack
        header.font = .systemFont(ofSize: 17)
        contentView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            header.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        ])
        
        text.textColor = .ypGray
        text.font = .systemFont(ofSize: 17)
        contentView.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            text.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            text.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
