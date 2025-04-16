//
//  TaskPreviewViewController.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

import UIKit

class TaskPreviewViewController: UIViewController {

    var presenter: TaskPreviewPresenterInput?

    private let task: TaskItem

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let additionalLabel = UILabel()
    private let containerView = UILabel()

    init(task: TaskItem) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.gray
        view.layer.cornerRadius = 16
        view.clipsToBounds = true

        setupViews()
        layout()
        populate()
    }

    private func setupViews() {
        titleLabel.font = AppFont.Style.button
        titleLabel.textColor = AppColor.white
        titleLabel.numberOfLines = 1

        descriptionLabel.font = AppFont.Style.caption
        descriptionLabel.textColor = AppColor.white
        descriptionLabel.numberOfLines = 2

        additionalLabel.font = AppFont.Style.caption
        additionalLabel.textColor = AppColor.white.withAlphaComponent(0.7)
        additionalLabel.numberOfLines = 1

        view.addSubviews(containerView)
        containerView.addSubviews(titleLabel, descriptionLabel, additionalLabel)
    }

    private func layout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            additionalLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            additionalLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            additionalLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            additionalLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    private func populate() {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        additionalLabel.text = task.createdAt
    }
}

extension TaskPreviewViewController: TaskPreviewViewInput {

    
}
