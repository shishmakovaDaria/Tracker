//
//  WeekDayMarshalling.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 17.06.2023.
//

import Foundation
import UIKit

final class WeekDayMarshalling {
    func makeString(scheduleSet: Set<WeekDay>) -> String {
        var string = ""
        for day in scheduleSet {
            string.append(contentsOf: "\(day.makeInt(day: day))")
        }
        
        return string
    }
    
    func makeWeekDaySetFromString(scheduleString: String) -> Set<WeekDay> {
        var set = Set<WeekDay>()
        for index in scheduleString.indices {
            let character = scheduleString[index]
            let int = character.wholeNumberValue ?? 0
            set.insert(WeekDay.monday.makeWeekDay(filterWeekday: int))
        }
        
        return set
    }
}
