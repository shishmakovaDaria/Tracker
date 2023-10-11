//
//  EditCategoryViewModel.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 10.10.2023.
//

import Foundation

final class EditCategoryViewModel {
    
    @Observable
    private(set) var newCategory: String = ""
    private let trackerCategoryStore: TrackerCategoryStore
    var category = ""
    
    convenience init() {
        self.init(trackerCategoryStore: TrackerCategoryStore())
    }

    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
    }
    
    func newCategoryCreated(text: String) {
        newCategory = text
    }
    
    func editCategory() {
        try? trackerCategoryStore.editCategory(categoryToEdit: category, newCategory: newCategory)
    }
}
