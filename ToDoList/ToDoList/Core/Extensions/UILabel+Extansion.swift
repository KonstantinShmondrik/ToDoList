//
//  UILabel+Extansion.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 15.04.2025.
//

import UIKit

extension UILabel {
    
    func setStrikeThrough(
        text: String,
        color: UIColor? = nil,
        style: NSUnderlineStyle = .single
    ) {
        var attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: style.rawValue
        ]
        
        if let color = color {
            attributes[.strikethroughColor] = color
        }
        
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    func resetStrikeThrough(text: String? = nil) {
        if let text = text {
            self.attributedText = nil
            self.text = text
        } else if let currentText = self.attributedText?.string {
            self.attributedText = nil
            self.text = currentText
        }
    }
}
