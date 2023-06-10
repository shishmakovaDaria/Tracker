//
//  TextFieldWithPadding.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 02.06.2023.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    var textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    func isValid() -> Bool {
        guard let text = self.text else { return false }
        guard text.count <= 38 else { return false }
        
        return true
    }
}
