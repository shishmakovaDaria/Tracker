//
//  TrackerStore.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 17.06.2023.
//

import Foundation
import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidName
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedule
}

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: IndexPath
        let newIndex: IndexPath
    }
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let updatedIndexes: [IndexPath]
    let movedIndexes: Set<Move>
}

protocol TrackerStoreDelegate: AnyObject {
    func store(
        _ store: TrackerStore,
        didUpdate update: TrackerStoreUpdate
    )
}

final class TrackerStore: NSObject {
    private let uiColorMarshalling = UIColorMarshalling()
    private let weekDayMarshalling = WeekDayMarshalling()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!

    weak var delegate: TrackerStoreDelegate?
    private var insertedIndexes: [IndexPath]?
    private var deletedIndexes: [IndexPath]?
    private var updatedIndexes: [IndexPath]?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
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
    
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.decodingErrorInvalidName
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        guard let colorHex = trackerCoreData.colorHex else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        guard let scheduleSting = trackerCoreData.scheduleString else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        
        return Tracker(id: id,
                       name: name,
                       color: uiColorMarshalling.color(from: colorHex),
                       emogi: emoji,
                       schedule: weekDayMarshalling.makeWeekDaySetFromString(scheduleString: scheduleSting))
    }
    
    func addNewTracker(_ newTracker: Tracker, currentCategory: String) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = newTracker.id
        trackerCoreData.name = newTracker.name
        trackerCoreData.emoji = newTracker.emogi
        trackerCoreData.colorHex = uiColorMarshalling.hexString(from: newTracker.color)
        trackerCoreData.scheduleString = weekDayMarshalling.makeString(scheduleSet: newTracker.schedule)
        let categoriesFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoriesFetchRequest.predicate = NSPredicate(format: "header = '\(currentCategory)'")
        let categories = try context.fetch(categoriesFetchRequest)
        trackerCoreData.category = categories.first
        try context.save()
    }
    
    func trackersForCurrentCategory(currentCategory: String) -> [Tracker] {
        var currentTrackers = [Tracker]()
        let trackersFetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        guard let objects = try? context.fetch(trackersFetchRequest) else { return [Tracker]() }
        
        for object in objects {
            if object.category?.header == currentCategory {
                guard let newTracker = try? tracker(from: object) else { return [Tracker]() }
                currentTrackers.append(newTracker)
            }
        }
        
        return currentTrackers
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = [IndexPath]()
        deletedIndexes = [IndexPath]()
        updatedIndexes = [IndexPath]()
        movedIndexes = Set<TrackerStoreUpdate.Move>()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!,
                updatedIndexes: updatedIndexes!,
                movedIndexes: movedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.append(indexPath)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.append(indexPath)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.append(indexPath)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath, newIndex: newIndexPath))
        @unknown default:
            fatalError()
        }
    }
}
