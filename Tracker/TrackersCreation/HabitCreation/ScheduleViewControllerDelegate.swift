//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 11.10.2023.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func addSchedule(chosenSchedule: Set<WeekDay>)
}
