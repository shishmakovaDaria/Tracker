//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 01.07.2023.
//

import Foundation
import UIKit

final class OnboardingPageViewController: UIViewController {
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        label.textColor = .ypBlack
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 2
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304)
        ])
        
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84)
        ])
    }
    
    @objc private func buttonDidTap(_ sender: Any?) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = TabBarController()
    }
    
    func setBackgroundImage(image: UIImage) {
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
}
