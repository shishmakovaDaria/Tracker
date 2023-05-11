//
//  ViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 24.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addTopView()
        addStar()
    }
    
    @IBAction private func plusButtonDidTap(_ sender: Any?) {
        // to be done
    }
    
    private func addTopView() {
        let topView = UIView()
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 630)
        ])
        
        let label = UILabel()
        label.text = "Трекеры"
        label.font = .boldSystemFont(ofSize: 34)
        topView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: topView.topAnchor, constant: 88)
        ])
        
        let plusButton = UIButton.systemButton(
            with: UIImage(named: "Plus")!,
            target: self,
            action: nil)
        plusButton.addTarget(self, action: #selector(plusButtonDidTap(_:)), for: .touchUpInside)
        plusButton.tintColor = .black
        topView.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 18),
            plusButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 57),
            plusButton.heightAnchor.constraint(equalToConstant: 18),
            plusButton.widthAnchor.constraint(equalToConstant: 19)
        ])
        
        let searchTextField = UISearchTextField()
        searchTextField.text = "Поиск"
        searchTextField.textColor = .ypGray
        searchTextField.backgroundColor = UIColor(red: 118, green: 118, blue: 128, alpha: 0.12)
        topView.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            searchTextField.topAnchor.constraint(equalTo: topView.topAnchor, constant: 136),
            searchTextField.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        topView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: topView.topAnchor, constant: 91)
        ])
    }
    
    private func addStar() {
        let star = UIImageView()
        star.image = UIImage(named: "Star")
        star.clipsToBounds = true
        view.addSubview(star)
        star.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            star.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            star.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330),
            star.heightAnchor.constraint(equalToConstant: 80),
            star.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: star.bottomAnchor, constant: 8)
        ])
        
    }
}

