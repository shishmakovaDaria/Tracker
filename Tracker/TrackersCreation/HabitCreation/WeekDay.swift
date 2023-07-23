//
//  WeekDay.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 09.06.2023.
//

import Foundation

enum WeekDay: String {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
    
    private var sortOrder: Int {
        switch self {
        case .monday:
            return 0
        case .tuesday:
            return 1
        case .wednesday:
            return 2
        case .thursday:
            return 3
        case .friday:
            return 4
        case .saturday:
            return 5
        case .sunday:
            return 6
        }
    }
    
    func makeWeekDay(filterWeekday: Int) -> WeekDay {
        var day = WeekDay.monday
        if filterWeekday == 1 { day = .sunday }
        if filterWeekday == 2 { day = .monday }
        if filterWeekday == 3 { day = .tuesday }
        if filterWeekday == 4 { day = .wednesday }
        if filterWeekday == 5 { day = .thursday }
        if filterWeekday == 6 { day = .friday }
        if filterWeekday == 7 { day = .saturday }
        return day
    }
    
    func makeInt(day: WeekDay) -> Int {
        var int = Int()
        if day == .sunday { int = 1 }
        if day == .monday { int = 2 }
        if day == .tuesday { int = 3 }
        if day == .wednesday { int = 4 }
        if day == .thursday { int = 5 }
        if day == .friday { int = 6 }
        if day == .saturday { int = 7 }
        return int
    }
    
    static func <(lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
    
    func makeString(_ schedule: Set<WeekDay>) -> String {
        var scheduleArray = [WeekDay]()
        for day in schedule {
            scheduleArray.append(day)
        }
        scheduleArray.sort{$0<$1}
        
        var scheduleRawArray = [String]()
        for day in scheduleArray {
            scheduleRawArray.append(day.rawValue)
        }
        
        var scheduleString = ""
        
        if scheduleRawArray.count == 7 {
            scheduleString = "Каждый день"
        } else {
            scheduleString = scheduleRawArray.joined(separator: ", ")
        }
        
        return scheduleString
    }
}
