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
    private let trackerCategoryStore: TrackerCategoryStore
    var currentCategory = ""
    
    convenience init() {
        self.init(trackerCategoryStore: TrackerCategoryStore())
    }

    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.categories
    }
    
    func categoryAtIndexPath(at indexPath: IndexPath) -> String {
        return categories[indexPath.row]
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func storeCategory(_ store: TrackerCategoryStore) {
        categories = trackerCategoryStore.categories
    }
}
