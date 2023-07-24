//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 08.07.2023.
//

import Foundation
import UIKit

final class CategoryViewModel {
    
    @Observable
    private(set) var categories: [String] = []
    private let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    var currentCategory = ""
    
    convenience init() {
        self.init(trackerStore: TrackerStore(), trackerCategoryStore: TrackerCategoryStore(), trackerRecordStore: TrackerRecordStore())
    }

    init(trackerStore: TrackerStore, trackerCategoryStore: TrackerCategoryStore, trackerRecordStore: TrackerRecordStore) {
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.categories
    }
    
    func categoryAtIndexPath(at indexPath: IndexPath) -> String {
        return categories[indexPath.row]
    }
    
    func deleteCategory(categoryToDelete: String) {
        let trackers = self.trackerStore.trackersForCurrentCategory(currentCategory: categoryToDelete)
        for tracker in trackers {
            try? trackerRecordStore.removeAllRecordsOfTracker(tracker.id)
            try? trackerStore.deleteTracker(tracker.id)
        }
        try? trackerCategoryStore.deleteCategory(categoryToDelete: categoryToDelete)
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func storeCategory(_ store: TrackerCategoryStore) {
        categories = trackerCategoryStore.categories
    }
}
