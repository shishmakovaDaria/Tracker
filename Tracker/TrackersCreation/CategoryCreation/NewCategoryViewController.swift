//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 02.06.2023.
//

import Foundation
import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func addNewCategory(newCategory: String)
}

final class NewCategoryViewController: UIViewController {
    
    private var newCategory: String?
    private let categoryName = CustomTextField()
    private let doneButton = UIButton()
    private let trackerCategoryStore = TrackerCategoryStore()
    var delegate: NewCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
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
        
        categoryName.placeholder = "Введите название категории"
        categoryName.textColor = .ypBlack
        categoryName.font = .systemFont(ofSize: 17)
        categoryName.backgroundColor = .background
        categoryName.layer.cornerRadius = 16
        categoryName.clearButtonMode = .whileEditing
        categoryName.returnKeyType = .go
        categoryName.becomeFirstResponder()
        categoryName.delegate = self
        view.addSubview(categoryName)
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryName.heightAnchor.constraint(equalToConstant: 75),
            categoryName.topAnchor.constraint(equalTo: view.topAnchor, constant: 87)
        ])
        
        doneButton.backgroundColor = .ypGray
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.ypWhite, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        doneButton.isEnabled = false
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
    
    @objc private func doneButtonDidTap(_ sender: Any?) {
        delegate?.addNewCategory(newCategory: newCategory ?? "")
        try! trackerCategoryStore.addNewCategory(newCategory ?? "")
        dismiss(animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryName.resignFirstResponder()
        
        if let text = categoryName.text {
            newCategory = text
        }
        
        doneButton.backgroundColor = .ypBlack
        doneButton.isEnabled = true
        
        return true
    }
}
