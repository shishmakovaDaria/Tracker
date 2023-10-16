//
//  ScheduleViewModel.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 11.10.2023.
//

import Foundation

final class ScheduleViewModel {
    let days = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    var schedule = Set<WeekDay>()
    var delegate: ScheduleViewControllerDelegate?
    
    func updateCurrentSchedule(senderTag: Int, senderIsOn: Bool) {
        let daysOfWeek: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        let day = daysOfWeek[safe: senderTag]
        
        if let day = day {
            if senderIsOn {
                schedule.insert(day)
            } else {
                schedule.remove(day)
            }
        }
    }
    
    func addSchedule() {
        delegate?.addSchedule(chosenSchedule: schedule)
    }
}
