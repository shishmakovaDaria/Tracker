//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 18.06.2023.
//

import Foundation
import CoreData
import UIKit

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
}

protocol TrackerRecordStoreDelegate: AnyObject {
    func store(_ store: TrackerRecordStore)
}

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!

    weak var delegate: TrackerRecordStoreDelegate?
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true)
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
    
    var trackersRecords: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackersRecords = try? objects.map({ try self.trackerRecord(from: $0)})
        else { return [] }
        return trackersRecords
    }
    
    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.id else {
            throw TrackerRecordStoreError.decodingErrorInvalidId
        }
        guard let date = trackerRecordCoreData.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidDate
        }
        
        return TrackerRecord(id: id,
                             date: date)
    }
    
    func addNewTrackerRecord(_ newTrackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = newTrackerRecord.id
        trackerRecordCoreData.date = newTrackerRecord.date
        var currentTracker: TrackerCoreData?
        let trackerFetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let trackers = try context.fetch(trackerFetchRequest)
        for tracker in trackers {
            if tracker.id == newTrackerRecord.id {
                currentTracker = tracker
            }
        }
        trackerRecordCoreData.tracker = currentTracker
        try context.save()
    }
    
    func removeRecord(_ trackerRecord: TrackerRecord) throws {
        guard let objects = fetchedResultsController.fetchedObjects else { return }
        var recordInCoreData: TrackerRecordCoreData?
        
        for record in objects {
            let isSameDay = Calendar.current.isDate(record.date ?? Date(), inSameDayAs: trackerRecord.date)
            if record.id == trackerRecord.id && isSameDay {
                recordInCoreData = record
            }
        }
        
        guard let recordInCoreData = recordInCoreData else { return }
        
        context.delete(recordInCoreData)
        try context.save()
    }
    
    func removeAllRecordsOfTracker(_ trackerId: UUID) throws {
        guard let records = fetchedResultsController.fetchedObjects else { return }
        
        for record in records {
            if record.id == trackerId {
                context.delete(record)
                try context.save()
            }
        }
    }
    
    func removeAllRecords() throws {
        guard let records = fetchedResultsController.fetchedObjects else { return }
        
        for record in records {
            context.delete(record)
            try context.save()
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(self)
    }
}
