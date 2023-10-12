//
//  TrackersCellDelegate.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 11.10.2023.
//

import Foundation

protocol TrackersCellDelegate: AnyObject {
    func markTrackerAsDone(id: UUID, at indexPath: IndexPath)
    func unmarkTrackerAsDone(id: UUID, at indexPath: IndexPath)
}
