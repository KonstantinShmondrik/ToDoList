//
//  File.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import UIKit

extension UIView {

    static var reuseId: String { String(describing: self) }

    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach(self.addSubview)
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(self.addSubview)
    }
}
