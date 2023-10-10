//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 23.07.2023.
//

import Foundation
import UIKit

final class EditCategoryViewController: UIViewController {
    var viewModel: EditCategoryViewModel?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Редактирование категории"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var categoryName: CustomTextField = {
        let categoryName = CustomTextField()
        categoryName.text = viewModel?.category
        categoryName.textColor = .ypBlack
        categoryName.font = .systemFont(ofSize: 17)
        categoryName.backgroundColor = .background
        categoryName.layer.cornerRadius = 16
        categoryName.clearButtonMode = .whileEditing
        categoryName.returnKeyType = .go
        categoryName.becomeFirstResponder()
        categoryName.delegate = self
        return categoryName
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.backgroundColor = .ypGray
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.ypWhite, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        doneButton.isEnabled = false
        doneButton.addTarget(self, action: #selector(doneButtonDidTap(_:)), for: .touchUpInside)
        return doneButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        viewModel?.$newCategory.bind { [weak self] _ in
            self?.doneButton.backgroundColor = .ypBlack
            self?.doneButton.isEnabled = true
        }
    }
    
    @objc private func doneButtonDidTap(_ sender: Any?) {
        viewModel?.editCategory()
        dismiss(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [label, categoryName, doneButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            categoryName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryName.heightAnchor.constraint(equalToConstant: 75),
            categoryName.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

//MARK: - UITextFieldDelegate
extension EditCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryName.resignFirstResponder()
        
        if let text = categoryName.text {
            self.viewModel?.newCategoryCreated(text: text)
        }
        
        return true
    }
}

