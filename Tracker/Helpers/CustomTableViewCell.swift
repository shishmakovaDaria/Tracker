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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    
    lazy var header: UILabel = {
        let header = UILabel()
        header.textColor = .ypBlack
        header.font = .systemFont(ofSize: 17)
        return header
    }()
    
    private lazy var text: UILabel = {
        let text = UILabel()
        text.textColor = .ypGray
        text.font = .systemFont(ofSize: 17)
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSecondLabel(chosen: String) {
        text.text = chosen
        stackView.addArrangedSubview(text)
    }
    
    private func setupUIAndConstraints() {
        let view = UIView(frame: contentView.frame)
        view.backgroundColor = .background
        backgroundView = view
        accessoryType = .disclosureIndicator
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(header)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 56)
        ])
    }
}
