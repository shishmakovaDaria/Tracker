//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 02.06.2023.
//

import Foundation
import UIKit

final class NewCategoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
    }
    
    private func configureView() {
        let label = UILabel()
        label.text = "Новая категория"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
        
        let categoryName = CustomTextField()
        categoryName.text = "Введите название категории"
        categoryName.textColor = .ypGray
        categoryName.font = .systemFont(ofSize: 17)
        categoryName.backgroundColor = .backgroundDay
        categoryName.layer.cornerRadius = 16
        view.addSubview(categoryName)
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryName.heightAnchor.constraint(equalToConstant: 75),
            categoryName.topAnchor.constraint(equalTo: view.topAnchor, constant: 87)
        ])
        
        let doneButton = UIButton()
        doneButton.backgroundColor = .ypGray
        doneButton.setTitle("Готово", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(doneButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    @IBAction private func doneButtonDidTap(_ sender: Any?) {
        //to be done
    }
}
