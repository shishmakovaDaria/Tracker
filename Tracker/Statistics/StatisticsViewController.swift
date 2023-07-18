//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 11.05.2023.
//

import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        view.backgroundColor = .ypWhite
        
        let label = UILabel()
        label.text = "Statistics".localized()
        label.font = .boldSystemFont(ofSize: 34)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 96)
        ])
    }
    // to be done
}
