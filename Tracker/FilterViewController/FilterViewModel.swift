//
//  FilterViewModel.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 10.10.2023.
//

import Foundation

final class FilterViewModel {
    let filters = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    var currentFiler: TrackerFilter?
    var delegate: FilterViewControllerDelegate?
    
    func filterIsSelected(filter: Int) {
        currentFiler = TrackerFilter(rawValue: filters[filter])
        delegate?.filterCategories(newFilter: currentFiler ?? .allTrackers)
    }
}
