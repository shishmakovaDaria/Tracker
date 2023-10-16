//
//  HabitCreationViewModel.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 11.10.2023.
//

import Foundation
import UIKit

final class HabitCreationViewModel {
    
    @Observable
    private(set) var trackersName: String = ""
    
    @Observable
    private(set) var trackersSchedule = Set<WeekDay>()
    
    @Observable
    private(set) var trackersEmoji: String = ""
    
    @Observable
    private(set) var trackersColor = UIColor.clear
    
    @Observable
    private(set) var trackersCategory: String = ""
    
    var delegate: CreationViewControllerDelegate?
    
    func trackerNameCreated(name: String) {
        trackersName = name
    }
    
    func scheduleCreated(schedule: Set<WeekDay>) {
        trackersSchedule = schedule
    }
    
    func emojiChosen(emoji: String) {
        trackersEmoji = emoji
    }
    
    func colorChosen(color: UIColor) {
        trackersColor = color
    }
    
    func categoryChosen(category: String) {
        trackersCategory = category
    }
    
    func allParametersChosen() -> Bool {
        if trackersCategory.isEmpty == false,
           trackersName.isEmpty == false,
           trackersEmoji.isEmpty == false,
           trackersSchedule.isEmpty == false,
           trackersColor != UIColor() {
            return true
        }
        return false
    }
    
    func createTracker() {
        let newTracker = Tracker(
            id: UUID(),
            name: trackersName,
            color: trackersColor,
            emoji: trackersEmoji,
            pinned: false,
            schedule: trackersSchedule)
        delegate?.addNewTracker(tracker: newTracker, header: trackersCategory)
    }
}
