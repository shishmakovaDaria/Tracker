//
//  Protocol.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 19.07.2023.
//

import Foundation

protocol EditingViewControllerDelegate: AnyObject {
    func updateTracker(tracker: Tracker, header: String)
}
