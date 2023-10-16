//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 12.10.2023.
//

import Foundation

final class TrackersViewModel {
    
    @Observable
    private(set) var visibleCategories: [TrackerCategory] = []
    
    @Observable
    private(set) var currentDate: Date?
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var completedTrackers: [TrackerRecord] = []
    private(set) var trackerFiler = TrackerFilter.allTrackers
    private var searchText: String?
    
    private let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    private let analyticsService: AnalyticsService
    
    convenience init() {
        self.init(
            trackerStore: TrackerStore(),
            trackerCategoryStore: TrackerCategoryStore(),
            trackerRecordStore: TrackerRecordStore(),
            analyticsService: AnalyticsService()
        )
    }

    init(trackerStore: TrackerStore, trackerCategoryStore: TrackerCategoryStore, trackerRecordStore: TrackerRecordStore, analyticsService: AnalyticsService) {
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        self.analyticsService = analyticsService
        
        trackerStore.delegate = self
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        
        if trackerCategoryStore.categories != [] {
            categories = updateCategoriesFromStore()
        }
        completedTrackers = trackerRecordStore.trackersRecords
    }
    
    func updateDatePickerDate(date: Date) {
        currentDate = date
        reloadVisibleCategories()
    }
    
    func updateSearchText(text: String) {
        searchText = text
        reloadVisibleCategories()
    }
    
    func viewWillAppear() {
        analyticsService.mainIsOpened()
    }
    
    func viewWillDisappear() {
        analyticsService.mainIsClosed()
    }
    
    func editButtonDidTap() {
        analyticsService.didTapEditOnMain()
    }
    
    func filterButtonDidTap() {
        analyticsService.didTapFilterOnMain()
    }
    
    func didTapDelete() {
        analyticsService.didTapDeleteOnMain()
    }
    
    func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: currentDate ?? Date())
            return trackerRecord.id == id && isSameDay
        }
    }
    
    func pinTracker(indexPath: IndexPath, cell: TrackersCell) {
        let currentTracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        if currentTracker.pinned == false {
            cell.setupPin(pinned: true)
        } else {
            cell.setupPin(pinned: false)
        }
        try? trackerStore.updatePin(currentTracker.id, currentPinned: !currentTracker.pinned)
    }
    
    func provideActionName(indexPath: IndexPath) -> String {
        let currentTracker = findTracker(indexPath: indexPath)
        
        var firstActionName: String {
            if currentTracker.pinned == false {
                return "Закрепить"
            } else {
                return "Открепить"
            }
        }
        return firstActionName
    }
    
    func findTracker(indexPath: IndexPath) -> Tracker {
        visibleCategories[indexPath.section].trackers[indexPath.row]
    }
    
    func deleteTracker(indexPath: IndexPath) {
        let currentTracker = findTracker(indexPath: indexPath)
        
        try? self.trackerRecordStore.removeAllRecordsOfTracker(currentTracker.id)
        try? self.trackerStore.deleteTracker(currentTracker.id)
    }
    
    func configureCellModel(indexPath: IndexPath) -> TrackersCellModel {
        let currentTracker = findTracker(indexPath: indexPath)
        
        return TrackersCellModel(
            name: currentTracker.name,
            color: currentTracker.color,
            emoji: currentTracker.emoji,
            isCompletedToday: isTrackerCompletedToday(id: currentTracker.id),
            completedDays: findRecord(idToFind: currentTracker.id),
            pinned: currentTracker.pinned
        )
    }
    
    func findRecord(idToFind: UUID) -> Int {
        completedTrackers.filter { $0.id == idToFind}.count
    }
    
    func findCategory(trackerId: UUID) -> String {
        trackerStore.currentCategory(trackerId)
    }
    
    func handleButtonTapped(indexPath: IndexPath) {
        analyticsService.didTapTrackerOnMain()
        let currentTracker = findTracker(indexPath: indexPath)
        
        if isTrackerCompletedToday(id: currentTracker.id) {
            unmarkTrackerAsDone(id: currentTracker.id)
        } else {
            markTrackerAsDone(id: currentTracker.id)
        }
    }
    
    private func markTrackerAsDone(id: UUID) {
        let today = Date()
        guard let currentDate = currentDate else { return }
        if Calendar.current.isDate(today, inSameDayAs: currentDate) || currentDate < today  {
            let trackerRecord = TrackerRecord(id: id, date: currentDate)
            try? trackerRecordStore.addNewTrackerRecord(trackerRecord)
        } else {
            return
        }
    }
    
    private func unmarkTrackerAsDone(id: UUID) {
        let trackerRecord = TrackerRecord(id: id, date: currentDate ?? Date())
        try! trackerRecordStore.removeRecord(trackerRecord)
    }
    
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: currentDate ?? Date())
        let filterWeekdayEnumCase = WeekDay.monday.makeWeekDay(filterWeekday: filterWeekday)
        let filterText = (searchText ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                                    tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay == filterWeekdayEnumCase
                } == true
                
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                header: category.header,
                trackers: trackers
            )
        }
    }
    
    private func updateCategoriesFromStore() -> [TrackerCategory] {
        var allCategories: [TrackerCategory] = []
        
        let pinnedTrackers = trackerStore.trackers.filter { tracker in
            return tracker.pinned == true
        }
        
        if pinnedTrackers.count != 0 {
            allCategories.append(TrackerCategory(
                header: "Закрепленные",
                trackers: pinnedTrackers))
        }
        
        let otherCategories = trackerCategoryStore.categories.map { category in
            let trackersInCurrentCategory = trackerStore.trackersForCurrentCategory(currentCategory: category)
            
            return TrackerCategory(header: category,
                                   trackers: trackersInCurrentCategory)
        }
        for category in otherCategories {
            allCategories.append(category)
        }
        
        return allCategories
    }
}

//MARK: - CreationViewControllerDelegate
extension TrackersViewModel: CreationViewControllerDelegate {
    func addNewTracker(tracker: Tracker, header: String) {
        try? trackerStore.addNewTracker(tracker, currentCategory: header)
    }
}

//MARK: - EditingViewControllerDelegate
extension TrackersViewModel: EditingViewControllerDelegate {
    func updateTracker(tracker: Tracker, header: String) {
        try? trackerStore.updateTracker(tracker, currentCategory: header)
    }
}

//MARK: - FilterViewControllerDelegate
extension TrackersViewModel: FilterViewControllerDelegate {
    func filterCategories(newFilter: TrackerFilter) {
        trackerFiler = newFilter
        
        switch newFilter {
        case .allTrackers:
            visibleCategories = categories
            reloadVisibleCategories()
        case .trackersForToday:
            currentDate = Date()
            visibleCategories = categories
            reloadVisibleCategories()
        case .done:
            visibleCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let condition = isTrackerCompletedToday(id: tracker.id) == true
                    
                    return condition
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(
                    header: category.header,
                    trackers: trackers
                )
            }
        case .notDone:
            visibleCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let condition = isTrackerCompletedToday(id: tracker.id) == false
                    
                    return condition
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(
                    header: category.header,
                    trackers: trackers
                )
            }
        }
    }
}


//MARK: - TrackerStoreDelegate
extension TrackersViewModel: TrackerStoreDelegate {
    func store(_ store: TrackerStore) {
        categories = updateCategoriesFromStore()
        visibleCategories = categories
        reloadVisibleCategories()
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension TrackersViewModel: TrackerCategoryStoreDelegate {
    func storeCategory(_ store: TrackerCategoryStore) {
        categories = updateCategoriesFromStore()
        visibleCategories = categories
        reloadVisibleCategories()
    }
}

//MARK: - TrackerRecordStoreDelegate
extension TrackersViewModel : TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore) {
        completedTrackers = trackerRecordStore.trackersRecords
    }
}
