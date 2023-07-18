//
//  String.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 08.06.2023.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
    
    static func getDay(count: UInt) -> String {
        let formatString: String = NSLocalizedString(
            "days count",
            tableName: "LocalizableDict",
            bundle: .main,
            value: "day",
            comment: "format to be found in Localized.stringsdict")
        
        let resultString = String.localizedStringWithFormat(formatString, count)
        return resultString
    }
}
