//
//  MainViewController.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

class MainViewController: UIViewController {

    private var tasksList: TasksListDTO?
    private let userRatesApiFactory = ApiFactory.makeTasksListApi()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red


        self.userRatesApiFactory.getList() { data, errorMessage in

            guard let data else {
                self.setAlert(title: Texts.AlertMessage.error, message: errorMessage ?? Texts.ErrorMessage.general)
                return
            }
            self.tasksList = data
            Logger.log("\(data)", level: .debug)
        }
    }


}

