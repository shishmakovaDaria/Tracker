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
        
        setUpLabel()
    }
    
    private func setUpLabel() {
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
