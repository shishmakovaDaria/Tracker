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
    
    convenience init() {
        self.init(trackerCategoryStore: TrackerCategoryStore())
    }

    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.categories
    }
    
    func configureCell(for cell: CustomTableViewCell, with indexPath: IndexPath, width: CGFloat) {
        cell.header.text = categories[indexPath.row]
        cell.accessoryType = .none
        
        if indexPath.row == categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func didTapRow(at indexPath: IndexPath) -> String {
        return categories[indexPath.row]
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func storeCategory(_ store: TrackerCategoryStore) {
        categories = trackerCategoryStore.categories
    }
}
