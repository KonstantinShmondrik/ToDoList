//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 16.04.2025.
//

import UIKit

class TaskDetailsViewController: UIViewController, UIGestureRecognizerDelegate {

    var presenter: TaskDetailsPresenterInput?

    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let additionalLabel = UILabel()

    private var descriptionTextViewBottomConstraint: NSLayoutConstraint!

    private lazy var notificationManager = NotificationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        notificationManager.subscribe(to: .keyboardWillHide)
        notificationManager.subscribe(to: .keyboardWillShow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        notificationManager.unsubscribe(from: .keyboardWillHide)
        notificationManager.unsubscribe(from: .keyboardWillShow)
    }

    private func addSubviews() {
        view.addSubviews(titleTextField, additionalLabel, descriptionTextView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40)
        ]

        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            additionalLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            additionalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            additionalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextViewBottomConstraint = descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        layoutConstraints += [
            descriptionTextView.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextViewBottomConstraint
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        view.backgroundColor = .black
        navigationController?.navigationBar.prefersLargeTitles = false

        titleTextField.font = AppFont.Style.largeTitle
        titleTextField.textColor = AppColor.white
        titleTextField.tintColor = AppColor.white
        titleTextField.text = presenter?.taskTitle
        titleTextField.placeholder = presenter?.taskTitle

        additionalLabel.font = AppFont.Style.regularTitle
        additionalLabel.textColor = AppColor.white.withAlphaComponent(0.7)
        additionalLabel.text = presenter?.taskCreatedAt

        descriptionTextView.font = AppFont.Style.regularTitle
        descriptionTextView.textColor = AppColor.white
        descriptionTextView.tintColor = AppColor.white
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.text = presenter?.taskDescription
    }

    private func setActions() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Назад", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = AppColor.yellow
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.semanticContentAttribute = .forceLeftToRight
        backButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        hideKeyboardWhenTappedAround()

        notificationManager.delegate = self
        descriptionTextView.delegate = self
    }

    @objc private func didTapLeftButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension TaskDetailsViewController: TaskDetailsViewInput {


}

extension TaskDetailsViewController: NotificationManagerDelegate {

    func performOnTrigger(_ notification: NotificationAction, object: Any?, userInfo: [AnyHashable : Any]?) {
        switch notification {
        case .keyboardWillShow:
            if let frame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
               let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
               let curveRawValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {

                let keyboardHeight = frame.height
                let options = UIView.AnimationOptions(rawValue: curveRawValue << 16)

                descriptionTextViewBottomConstraint.constant = -keyboardHeight
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        case .keyboardWillHide:
            if let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
               let curveRawValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {

                let options = UIView.AnimationOptions(rawValue: curveRawValue << 16)

                descriptionTextViewBottomConstraint.constant = -8
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        default:
            break
        }
    }
}

extension TaskDetailsViewController: UITextViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
