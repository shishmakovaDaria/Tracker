//
//  Array.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 11.10.2023.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
