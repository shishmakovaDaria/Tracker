//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Дарья Шишмакова on 17.07.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testViewController() {
        let vc = TrackersViewController()
        let trackerStore = TrackerStore()
        let trackerCategoryStore = TrackerCategoryStore()
        
        try! trackerStore.deleteAllTrackers()
        try! trackerCategoryStore.deleteAllCategories()
        
        try! trackerCategoryStore.addNewCategory("Важное")
        try! trackerStore.addDefaultTracker()
        
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testDarkTheme() {
        let vc = TrackersViewController()
        let trackerStore = TrackerStore()
        let trackerCategoryStore = TrackerCategoryStore()
        
        try! trackerStore.deleteAllTrackers()
        try! trackerCategoryStore.deleteAllCategories()
        
        try! trackerCategoryStore.addNewCategory("Важное")
        try! trackerStore.addDefaultTracker()
        
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
