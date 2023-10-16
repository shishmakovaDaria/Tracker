//
//  Tracker.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 01.06.2023.
//

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let pinned: Bool
    let schedule: Set<WeekDay>
}
