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
    var trackers = [Tracker]()
    weak var delegate: TrackersStorageDelegate?
    
    func addNewTracker(tracker: Tracker) {
        trackers.append(tracker)
        delegate?.dataUpdated()
    }
}
