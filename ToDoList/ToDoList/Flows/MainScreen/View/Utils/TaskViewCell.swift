//
//  TaskViewCell.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 15.04.2025.
//

import UIKit

protocol TaskViewCellDelegate: AnyObject {

    func didTapOnCheckBox(at indexPath: IndexPath)
}

class TaskViewCell: UITableViewCell {

    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let aditionalLabel = UILabel()
    private let separatorView = UIView()

    weak var delegate: TaskViewCellDelegate?

    var indexPath: IndexPath?

    var isCompleted = false {
        didSet {
            titleLabel.textColor = isCompleted ? AppColor.white.withAlphaComponent(0.7) : AppColor.white
            subtitleLabel.textColor = isCompleted ? AppColor.white.withAlphaComponent(0.7) : AppColor.white
            iconImageView.image = isCompleted ? UIImage(resource: .complitedIcon) : nil
            iconImageView.layer.borderColor = isCompleted ? AppColor.yellow.cgColor : AppColor.stroke.cgColor

            if isCompleted {
                titleLabel.setStrikeThrough(text: title ?? "", color: AppColor.white.withAlphaComponent(0.7))
            } else {
                titleLabel.resetStrikeThrough(text: title ?? "")
            }
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundView?.backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backgroundView?.backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        selectedBackgroundView = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        aditionalLabel.text = nil
        iconImageView.image = nil
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let iconPoint = iconImageView.convert(point, from: self)
        if iconImageView.bounds.contains(iconPoint) {
            return iconImageView
        }
        return super.hitTest(point, with: event)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        styleViews()
        setActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubviews(iconImageView ,containerView, separatorView)
        containerView.addSubviews(titleLabel, subtitleLabel, aditionalLabel)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
            ]

        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            containerView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ]

        aditionalLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            aditionalLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            aditionalLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 6),
            aditionalLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            aditionalLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ]

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func styleViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .clear

        iconImageView.layer.cornerRadius = 12
        iconImageView.clipsToBounds = false
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1.5
        iconImageView.layer.borderColor = AppColor.stroke.cgColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = .clear

        titleLabel.textColor = AppColor.white
        titleLabel.font = AppFont.Style.button
        titleLabel.numberOfLines = 0

        subtitleLabel.textColor = AppColor.white
        subtitleLabel.font = AppFont.Style.caption
        subtitleLabel.numberOfLines = 2

        aditionalLabel.textColor = AppColor.white.withAlphaComponent(0.7)
        aditionalLabel.font = AppFont.Style.caption
        aditionalLabel.numberOfLines = 0

        separatorView.backgroundColor = AppColor.stroke
    }

    private func setActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.addGestureRecognizer(tapGesture)
    }

    @objc func buttonTapped() {
        guard let indexPath else { return }
        delegate?.didTapOnCheckBox(at: indexPath)
    }
}

extension TaskViewCell {

    var title: String? {
        get { titleLabel.attributedText?.string ?? titleLabel.text }
        set {
            if let newValue = newValue {
                if isCompleted {
                    titleLabel.setStrikeThrough(text: newValue, color: AppColor.white.withAlphaComponent(0.7))
                } else {
                    titleLabel.resetStrikeThrough(text: newValue)
                }
            } else {
                titleLabel.attributedText = nil
                titleLabel.text = nil
            }
        }
    }

    var subtitle: String? {
        get { subtitleLabel.text }
        set { subtitleLabel.text = newValue }
    }

    var aditional: String? {
        get { aditionalLabel.text }
        set { aditionalLabel.text = newValue }
    }
}
