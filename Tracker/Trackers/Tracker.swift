//
//  Tracker.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 01.06.2023.
//

import Foundation
import UIKit

struct Tracker {
    let id: Int
    let name: String
    let color: UIColor
    let emogi: String
    let schedule: String
}

struct TrackerCategory {
    let header: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let id: UInt
    let date: Date
}
