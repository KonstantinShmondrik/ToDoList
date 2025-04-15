//
//  MainScreenViewInput.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

protocol MainScreenViewInput where Self: UIViewController {

    func setData(_ items: [TaskItem])
}
