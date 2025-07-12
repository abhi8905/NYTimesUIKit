//
//  EmptyStateView.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//


import UIKit
import NYTKit

final class EmptyStateView: UIView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    var retryAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        iconImageView.preferredSymbolConfiguration = symbolConfig
        iconImageView.tintColor = .secondaryLabel

        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textAlignment = .center
        
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        retryButton.setTitle(AppConstants.ButtonTitles.retry, for: .normal)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            iconImageView, titleLabel, messageLabel, retryButton
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(
                greaterThanOrEqualTo: leadingAnchor, constant: 20
            ),
            stack.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor, constant: -20
            )
        ])
    }

    func configure(
        title: String,
        message: String,
        systemImageName: String?,
        retryHandler: (() -> Void)? = nil
    ) {
        titleLabel.text = title
        messageLabel.text = message
        
        if let systemImageName = systemImageName {
            iconImageView.image = UIImage(systemName: systemImageName)
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }

        retryAction = retryHandler
        retryButton.isHidden = (retryHandler == nil)
    }

    @objc private func didTapRetry() {
        retryAction?()
    }
}
