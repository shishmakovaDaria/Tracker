//
//  TrackerEditingViewModel.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 10.10.2023.
//

import Foundation
import UIKit

final class TrackerEditingViewModel {
    
    @Observable
    private(set) var newTrackersName: String = ""
    
    @Observable
    private(set) var newTrackersSchedule = Set<WeekDay>()
    
    @Observable
    private(set) var newTrackersEmoji: String = ""
    
    @Observable
    private(set) var newTrackersColor = UIColor()
    
    @Observable
    private(set) var newTrackersCategory: String = ""
    
    let tableHeaders = ["Категория", "Расписание"]
    let emojies = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                   "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                   "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    let colors: [UIColor] = [.selection1, .selection2, .selection3, .selection4, .selection5, .selection6,
                             .selection7, .selection8, .selection9, .selection10, .selection11, .selection12,
                             .selection13, .selection14, .selection15, .selection16, .selection17, .selection18]
    
    var delegate: EditingViewControllerDelegate?
    var trackerToEdit: Tracker?
    var trackerRecord: Int?
    
    func updateValues(category: String) {
        newTrackersName = trackerToEdit?.name ?? ""
        newTrackersSchedule = trackerToEdit?.schedule ?? Set<WeekDay>()
        newTrackersEmoji = trackerToEdit?.emoji ?? ""
        newTrackersColor = trackerToEdit?.color ?? UIColor()
        newTrackersCategory = category
    }
    
    func newTrackerNameCreated(newName: String) {
        newTrackersName = newName
    }
    
    func newScheduleCreated(newSchedule: Set<WeekDay>) {
        newTrackersSchedule = newSchedule
    }
    
    func newEmojiChosen(newEmoji: String) {
        newTrackersEmoji = newEmoji
    }
    
    func newColorChosen(newColor: UIColor) {
        newTrackersColor = newColor
    }
    
    func newCategoryChosen(newCategory: String) {
        newTrackersCategory = newCategory
    }
    
    func allParametersChosen() -> Bool {
        if newTrackersName.isEmpty == false,
           newTrackersSchedule.isEmpty == false {
            return true
        }
        return false
    }
    
    func editTracker() {
        let updatedTracker = Tracker(
            id: trackerToEdit?.id ?? UUID(),
            name: newTrackersName,
            color: newTrackersColor,
            emoji: newTrackersEmoji,
            pinned: trackerToEdit?.pinned ?? false,
            schedule: newTrackersSchedule)
        delegate?.updateTracker(tracker: updatedTracker, header: newTrackersCategory)
    }
}
