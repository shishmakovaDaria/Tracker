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
    
    func makeInt(filterWeekday: Int) -> WeekDay {
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
    
    static func <(lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}
