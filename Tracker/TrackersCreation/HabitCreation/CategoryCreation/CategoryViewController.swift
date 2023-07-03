//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 02.06.2023.
//

import Foundation
import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func addCategory(chosenCategory: String)
}

final class CategoryViewController: UIViewController {
    
    private let tableView = UITableView()
    private let trackerCategoryStore = TrackerCategoryStore()
    private var categories: [String] = []
    private let placeholder = UIImageView()
    private let placeholderLabel = UILabel()
    private var tableViewHeightConstraint: NSLayoutConstraint?
    var delegate: CategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        if trackerCategoryStore.categories != [] {
            categories = trackerCategoryStore.categories
        }
        reloadPlaceholder()
        if categories.count > 7 {
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130).isActive = true
        }
    }
    
    private func configureView() {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
        
        let addButton = UIButton()
        addButton.backgroundColor = .ypBlack
        addButton.setTitle("Добавить категорию", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addButton.layer.cornerRadius = 16
        addButton.addTarget(self, action: #selector(addButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableViewHeightConstraint = NSLayoutConstraint(
            item: tableView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: CGFloat(trackerCategoryStore.categories.count*75))
        
        guard let tableViewHeightConstraint = tableViewHeightConstraint else { return }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            tableViewHeightConstraint
        ])
        
        placeholder.image = UIImage(named: "Star")
        placeholder.clipsToBounds = true
        view.addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.topAnchor.constraint(equalTo: view.topAnchor, constant: 295),
            placeholder.heightAnchor.constraint(equalToConstant: 80),
            placeholder.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        placeholderLabel.text = "Привычки и события можно объединить по смыслу"
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
        view.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)
        ])
    }
    
    private func reloadPlaceholder() {
        placeholder.isHidden = !categories.isEmpty
        placeholderLabel.isHidden = !categories.isEmpty
    }
    
    @objc private func addButtonDidTap(_ sender: Any?) {
        let vc = NewCategoryViewController()
        vc.delegate = self
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        cell.header.text = categories[indexPath.row]
        cell.accessoryType = .none
        
        if indexPath.row == categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
            cell.accessoryType = .checkmark
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indices = tableView.indexPathsForVisibleRows else { return }
        for index in indices {
            tableView.cellForRow(at: index)?.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        dismiss(animated: true)
        delegate?.addCategory(chosenCategory: categories[indexPath.row])
    }
}

//MARK: - NewCategoryViewControllerDelegate
extension CategoryViewController: NewCategoryViewControllerDelegate {
    func addNewCategory(newCategory: String) {
        categories.append(newCategory)
        tableViewHeightConstraint?.constant += 75
        if categories.count > 7 {
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130).isActive = true
        }
        
        reloadPlaceholder()
        tableView.reloadData()
    }
}
