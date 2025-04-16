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

    private var tableViewBottomConstraint: NSLayoutConstraint!

    private lazy var notificationManager = NotificationManager()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true

        notificationManager.subscribe(to: .keyboardWillShow)
        notificationManager.subscribe(to: .keyboardWillHide)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()

        presenter?.getData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        notificationManager.unsubscribe(from: .keyboardWillHide)
        notificationManager.unsubscribe(from: .keyboardWillShow)
    }


    init() {
        super.init(nibName: nil, bundle: nil)

        notificationManager.subscribe(to: .updateTaskList)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        notificationManager.unsubscribe(from: .updateTaskList)
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
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableViewBottomConstraint
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
        notificationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskViewCell.self)

        hideKeyboardWhenTappedAround()
        addButton.addTarget(self, action: #selector(didTabAddButton), for: .touchUpInside)
    }

    private func currentIndexPathForConfig(_ config: UIContextMenuConfiguration) -> IndexPath? {
        if let id = config.identifier as? String,
           let section = Int(id.prefix(1)),
           let row = Int(id.suffix(1)) {
            return IndexPath(row: row, section: section)
        }
        return nil
    }

    private func shareText(_ text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(
            x: self.view.bounds.midX,
            y: self.view.bounds.midY,
            width: 0,
            height: 0
        )
        activityVC.popoverPresentationController?.permittedArrowDirections = []

        self.present(activityVC, animated: true)
    }

    @objc func didTabAddButton() {
        presenter?.createNewTask()
    }
}

extension MainScreenViewController: UISearchBarDelegate {

}

extension MainScreenViewController: UITableViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        presenter?.goToTaskDitails(for: item)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = items[indexPath.row]

        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                return self.presenter?.makePreviewViewController(for: item)
            },
            actionProvider: { _ in
                return self.presenter?.makeContextMenuActions(for: item)
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

    func deleteItem(_ item: TaskItem) {
        presenter?.deleteItem(item)
    }

    func exportItem(_ item: TaskItem) {
        var combinedText = ""
        combinedText += "\(item.title)\n"
        combinedText += "\(item.description)\n"

        if let additional = item.createdAt, !additional.isEmpty {
            combinedText += "\(additional)\n"
        }

        shareText(combinedText.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func setData(_ items: [TaskItem]) {
        self.items = items
    }
}

extension MainScreenViewController: TaskViewCellDelegate {

    func didTapOnCheckBox(at indexPath: IndexPath) {
        guard let item = items.first(where: { $0.id == items[indexPath.row].id }) else { return }
        presenter?.completeItem(item)
    }
}

extension MainScreenViewController: NotificationManagerDelegate {

    func performOnTrigger(_ notification: NotificationAction, object: Any?, userInfo: [AnyHashable : Any]?) {
        switch notification {
        case .keyboardWillShow:
            if let frame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
               let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
               let curveRawValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {

                let keyboardHeight = frame.height
                let options = UIView.AnimationOptions(rawValue: curveRawValue << 16)

                tableViewBottomConstraint.constant = -keyboardHeight
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        case .keyboardWillHide:
            if let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
               let curveRawValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {

                let options = UIView.AnimationOptions(rawValue: curveRawValue << 16)

                tableViewBottomConstraint.constant = 0
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        case .updateTaskList:
            presenter?.getData()
        default:
            break
        }
    }
}
