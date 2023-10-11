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
    var viewModel: CategoryViewModel?
    var delegate: CategoryViewControllerDelegate?
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        tableView.separatorColor = .ypGray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.backgroundColor = .ypBlack
        addButton.setTitle("Добавить категорию", for: .normal)
        addButton.setTitleColor(.ypWhite, for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addButton.layer.cornerRadius = 16
        addButton.addTarget(self, action: #selector(addButtonDidTap(_:)), for: .touchUpInside)
        return addButton
    }()
    
    private lazy var placeholder: UIImageView = {
        let placeholder = UIImageView()
        placeholder.image = UIImage(named: "Star")
        placeholder.clipsToBounds = true
        return placeholder
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Привычки и события можно объединить по смыслу"
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
        return placeholderLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        viewModel?.$categories.bind { [weak self] _ in
            self?.updateTableView()
        }
        
        updateTableView()
    }
    
    @objc private func addButtonDidTap(_ sender: Any?) {
        let vc = NewCategoryViewController()
        vc.viewModel = NewCategoryViewModel()
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    private func updateTableView() {
        if viewModel?.categories.count ?? 0 > 7 {
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130).isActive = true
        }
        tableViewHeightConstraint?.constant = CGFloat((viewModel?.categories.count ?? 0)*75)
        tableView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
        placeholder.isHidden = !(viewModel?.categories ?? []).isEmpty
        placeholderLabel.isHidden = !(viewModel?.categories ?? []).isEmpty
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [label, tableView, addButton, placeholder, placeholderLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        tableViewHeightConstraint = NSLayoutConstraint(
            item: tableView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: CGFloat((viewModel?.categories.count ?? 0)*75))
        
        guard let tableViewHeightConstraint = tableViewHeightConstraint else { return }
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            tableViewHeightConstraint,
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.topAnchor.constraint(equalTo: view.topAnchor, constant: 295),
            placeholder.heightAnchor.constraint(equalToConstant: 80),
            placeholder.widthAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)
        ])
    }
}

//MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        
        cell.header.text = viewModel?.categoryAtIndexPath(at: indexPath)
        if cell.header.text == viewModel?.currentCategory {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        if indexPath.row == (viewModel?.categories.count ?? 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let chosenCategory = viewModel?.categoryAtIndexPath(at: indexPath)
        delegate?.addCategory(chosenCategory: chosenCategory ?? "")
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let categoryToEditOrDelete = viewModel?.categoryAtIndexPath(at: indexPath)
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in
                    let vc = EditCategoryViewController()
                    vc.viewModel = EditCategoryViewModel()
                    vc.viewModel?.category = categoryToEditOrDelete ?? ""
                    self?.present(vc, animated: true)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    let alert = UIAlertController(title: "Эта категория точно не нужна?",
                                                  message: nil,
                                                  preferredStyle: .actionSheet)
                    
                    let action1 = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel?.deleteCategory(categoryToDelete: categoryToEditOrDelete ?? "")
                    }
                    
                    let action2 = UIAlertAction(title: "Отменить", style: .cancel) {_ in
                        alert.dismiss(animated: true)
                    }
                    
                    alert.addAction(action1)
                    alert.addAction(action2)

                    self?.present(alert, animated: true)
                },
            ])
        })
    }
}
