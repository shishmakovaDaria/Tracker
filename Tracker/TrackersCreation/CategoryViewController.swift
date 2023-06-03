//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 02.06.2023.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController {
    
    let chosenCategory = "Важное"
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addTableView()
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
    }
    
    private func addPlaceholder() {
        let star = UIImageView()
        star.image = UIImage(named: "Star")
        star.clipsToBounds = true
        view.addSubview(star)
        star.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            star.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            star.topAnchor.constraint(equalTo: view.topAnchor, constant: 295),
            star.heightAnchor.constraint(equalToConstant: 80),
            star.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        let starLabel = UILabel()
        starLabel.text = "Привычки и события можно объединить по смыслу"
        starLabel.font = .systemFont(ofSize: 12, weight: .medium)
        starLabel.numberOfLines = 2
        starLabel.textAlignment = .center
        view.addSubview(starLabel)
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starLabel.topAnchor.constraint(equalTo: star.bottomAnchor, constant: 8),
            starLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            starLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)
        ])
    }
    
    private func addTableView() {
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            tableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    @IBAction private func addButtonDidTap(_ sender: Any?) {
        //to be done
        //present(NewCategoryViewController(), animated: true)
    }
}

//MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = chosenCategory
        cell.backgroundColor = .backgroundDay
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        dismiss(animated: true)
    }
}
