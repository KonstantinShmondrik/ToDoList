//
//  MainScreenViewController.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

class MainScreenViewController: UIViewController {

    private let tableView = UITableView()
    private let addButton = UIButton()
    private let searchBar = UISearchBar()
    private let bottomView = UIView()
    private let labelView = UILabel()
    private let strokeView = UIView()

    private var items: [TaskItem] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if !self.items.isEmpty {
                    labelView.text = self.items.count == 1 ? "1 задача" : "\(self.items.count) задач"
                    self.tableView.reloadData()
                } else {
                    labelView.text = "Нет задач"
                }
                tableView.reloadData()
            }

        }
    }

    var presenter: MainScreenPresenterInput?

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()

        presenter?.getData()
    }

    private func addSubviews() {
        view.addSubviews(searchBar, tableView, bottomView)
        bottomView.addSubviews(addButton, labelView, strokeView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ]

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        bottomView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 83)
        ]

        addButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            addButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5),
            addButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 68),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ]

        labelView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            labelView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            labelView.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ]

        strokeView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            strokeView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            strokeView.leftAnchor.constraint(equalTo: bottomView.leftAnchor),
            strokeView.rightAnchor.constraint(equalTo: bottomView.rightAnchor),
            strokeView.heightAnchor.constraint(equalToConstant: 0.33)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = .black
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.tintColor = AppColor.white
        searchBar.barTintColor = .clear
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = AppColor.white

            textField.attributedPlaceholder = NSAttributedString(
                string: "Поиск",
                attributes: [.foregroundColor: AppColor.white.withAlphaComponent(0.5)]
            )

            if let leftIconView = textField.leftView as? UIImageView {
                leftIconView.tintColor = AppColor.white.withAlphaComponent(0.5)
            }

            if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
                clearButton.tintColor = AppColor.white.withAlphaComponent(0.5)
            }

            textField.backgroundColor = AppColor.gray

            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 0),
                textField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 0),
                textField.topAnchor.constraint(equalTo: searchBar.topAnchor),
                textField.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor)
            ])
        }

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)

        addButton.setImage(UIImage(resource: .addButton), for: .normal)

        labelView.text = "Нет задач"
        labelView.font = AppFont.Style.caption
        labelView.textColor = AppColor.white

        bottomView.backgroundColor = AppColor.gray

        strokeView.backgroundColor = AppColor.stroke
    }

    private func setActions() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskViewCell.self)

        addButton.addTarget(self, action: #selector(didTabAddButton), for: .touchUpInside)
    }

    private func makePreviewViewController(for item: TaskItem) -> UIViewController {
        let vc = TaskPreviewViewController(task: item) // создаешь свой VC
        vc.preferredContentSize = CGSize(width: 300, height: 300)
        return vc
    }

    private func makeContextMenuActions(for item: TaskItem) -> UIMenu {
        let open = UIAction(title: "Открыть", image: UIImage(systemName: "doc.text")) { _ in
            self.openFullScreen(for: item)
        }

        let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//            self.deleteItem(item)
        }

        return UIMenu(title: "", children: [open, delete])
    }

    private func openFullScreen(for item: TaskItem) {
        let vc = TaskPreviewViewController(task: item)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func currentIndexPathForConfig(_ config: UIContextMenuConfiguration) -> IndexPath? {
        if let id = config.identifier as? String,
           let section = Int(id.prefix(1)),
           let row = Int(id.suffix(1)) {
            return IndexPath(row: row, section: section)
        }
        return nil
    }


    @objc func didTabAddButton() {
        Logger.log("didTabAddButton", level: .debug)
    }

}

extension MainScreenViewController: UISearchBarDelegate {

}

extension MainScreenViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = items[indexPath.row]

        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                return self.makePreviewViewController(for: item)
            },
            actionProvider: { _ in
                return self.makeContextMenuActions(for: item)
            }
        )
    }

    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = currentIndexPathForConfig(configuration),
              let cell = tableView.cellForRow(at: indexPath) as? TaskViewCell else {
            return nil
        }

        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear

        return UITargetedPreview(view: cell.contentView, parameters: parameters)
    }

}

extension MainScreenViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.title = items[indexPath.row].title
        cell.subtitle = items[indexPath.row].description
        cell.aditional = items[indexPath.row].createdAt
        cell.indexPath = indexPath
        cell.isCompleted = items[indexPath.row].isCompleted
        return cell
    }
    

}

extension MainScreenViewController: MainScreenViewInput {

    func setData(_ items: [TaskItem]) {
        self.items = items
    }
}

extension MainScreenViewController: TaskViewCellDelegate {

    func didTapOnCheckBox(at indexPath: IndexPath) {
        Logger.log("didTapOnCheckBox at\(indexPath)", level: .debug)
    }
}








// переместить
final class TaskPreviewViewController: UIViewController {

    private let task: TaskItem

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = AppColor.white
        titleLabel.numberOfLines = 2

        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = AppColor.white.withAlphaComponent(0.7)
        descriptionLabel.numberOfLines = 3

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
    }

    private func layout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
    }

    private func populate() {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
    }
}
