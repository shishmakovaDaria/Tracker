//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 10.10.2023.
//

import Foundation

final class StatisticsViewModel {
    
    @Observable
    private(set) var completedTrackers: Int = 0
    private let trackerRecordStore: TrackerRecordStore
    
    convenience init() {
        self.init(trackerRecordStore: TrackerRecordStore())
    }

    init(trackerRecordStore: TrackerRecordStore) {
        self.trackerRecordStore = trackerRecordStore
        trackerRecordStore.delegate = self
        completedTrackers = trackerRecordStore.trackersRecords.count
    }
}

//MARK: - TrackerRecordStoreDelegate
extension StatisticsViewModel: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore) {
        completedTrackers = trackerRecordStore.trackersRecords.count
    }
}
