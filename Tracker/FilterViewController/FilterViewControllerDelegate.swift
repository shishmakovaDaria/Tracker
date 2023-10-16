//
//  FilterViewControllerDelegate.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 10.10.2023.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func filterCategories(newFilter: TrackerFilter)
}
