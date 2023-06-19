//
//  CreationViewControllerDelegate.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 20.06.2023.
//

import Foundation

protocol CreationViewControllerDelegate: AnyObject {
    func addNewTracker(tracker: Tracker, header: String)
}
