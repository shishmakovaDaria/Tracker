//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 17.06.2023.
//

import Foundation
import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidHeader
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeCategory(_ store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    weak var delegate: TrackerCategoryStoreDelegate?
   
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.header, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    var categories: [String] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.category(from: $0)})
        else { return [] }
        return categories
    }
        
    func category(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> String {
        guard let category = trackerCategoryCoreData.header else {
            throw TrackerCategoryStoreError.decodingErrorInvalidHeader
        }
        return category
    }
    
    func addNewCategory(_ newCategory: String) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.header = newCategory
        try context.save()
    }
    
    func deleteAllCategories() throws {
        guard let objects = fetchedResultsController.fetchedObjects else { return }
        
        for object in objects {
            context.delete(object)
            try context.save()
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeCategory(self)
    }
}
