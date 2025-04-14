//
//  File.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//


import UIKit

extension UIViewController {

    func setAlert(title: String, message: String? = nil, actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        defer { present(alertController, animated: true) }
        guard let actions else { return }
        actions.forEach { alertController.addAction($0) }
    }

    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func presentCustomAlert(
        _ viewController: UIViewController,
        blurStyle: UIBlurEffect.Style = .regular,
        cornerRadius: CGFloat = 0
    ) {
        let containerVC = UIViewController()
        containerVC.modalPresentationStyle = .overFullScreen
        containerVC.view.backgroundColor = .black.withAlphaComponent(0.3)
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = containerVC.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerVC.view.addSubview(blurView)

        viewController.view.layer.cornerRadius = cornerRadius
        viewController.view.clipsToBounds = true
        viewController.modalPresentationStyle = .custom
        viewController.modalTransitionStyle = .crossDissolve

        DispatchQueue.main.async {
            self.present(containerVC, animated: false) {
                containerVC.present(viewController, animated: true, completion: nil)
            }
        }
    }

    func dismissCustomAlert(completion: (() -> Void)? = nil) {
        if let containerVC = presentedViewController {
            containerVC.dismiss(animated: false) {
                self.dismiss(animated: false, completion: completion)
            }
        }
    }
}
