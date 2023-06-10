//
//  Storage.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 06.06.2023.
//

import Foundation

protocol TrackersStorageDelegate: AnyObject {
    func dataUpdated()
}

final class TrackersStorage {
    
    static let shared = TrackersStorage()
    var categories = [TrackerCategory]()
    var trackers = [Tracker]()
    weak var delegate: TrackersStorageDelegate?
    
    func addNewTracker(tracker: Tracker, header: String) {
        trackers.append(tracker)
        if categories.count > 0,
           categories[0].header == header {
            let newTrackers = trackers
            let newCategory = TrackerCategory(header: header,
                                              trackers: newTrackers)
            self.categories = [newCategory]
        } else {
            categories.append(TrackerCategory(header: header, trackers: trackers))
        }
        
        delegate?.dataUpdated()
    }
}
