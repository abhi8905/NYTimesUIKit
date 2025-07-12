//
//  ArticleCell.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//


import NYTKit
import UIKit

final class ArticleCell: UICollectionViewCell {
    static let reuseID = UIConstants.Cell.articleReuseIdentifier

    private let thumb = UIImageView()
    private let titleLabel = UILabel()
    private let bylineLabel = UILabel()
    private let dateIcon = UIImageView(image: UIImage(systemName: AppConstants.Images.calendarIcon))
    private let dateLabel = UILabel()
    private let hStack = UIStackView()
    private let vStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIConstants.Spacing.contentSpacing,
            leading: UIConstants.Spacing.edgeInset,
            bottom: UIConstants.Spacing.contentSpacing,
            trailing: UIConstants.Spacing.edgeInset
        )

        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.layer.cornerRadius = UIConstants.Spacing.thumbnailSize / 2
        thumb.clipsToBounds = true
        thumb.contentMode = .scaleAspectFill

        titleLabel.font = UIConstants.Fonts.headline
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = UIConstants.Colors.primaryText

        bylineLabel.font = .italicSystemFont(ofSize: UIConstants.Fonts.subheadline.pointSize)
        bylineLabel.textColor = UIConstants.Colors.secondaryText
        bylineLabel.numberOfLines = 0
        bylineLabel.lineBreakMode = .byWordWrapping

        dateIcon.tintColor = UIConstants.Colors.secondaryText
        dateIcon.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.font = UIConstants.Fonts.subheadline
        dateLabel.textColor = UIConstants.Colors.secondaryText

        NSLayoutConstraint.activate([
            dateIcon.widthAnchor.constraint(equalToConstant: UIConstants.Fonts.subheadline.pointSize),
            dateIcon.heightAnchor.constraint(equalToConstant: UIConstants.Fonts.subheadline.pointSize)
        ])

        hStack.axis = .horizontal
        hStack.spacing = UIConstants.Spacing.stackSpacing
        hStack.alignment = .center
        hStack.addArrangedSubview(dateIcon)
        hStack.addArrangedSubview(dateLabel)

        vStack.axis = .vertical
        vStack.spacing = UIConstants.Spacing.stackSpacing
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(bylineLabel)
        vStack.addArrangedSubview(hStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(thumb)
        contentView.addSubview(vStack)

        NSLayoutConstraint.activate([
            thumb.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            thumb.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumb.widthAnchor.constraint(equalToConstant: UIConstants.Spacing.thumbnailSize),
            thumb.heightAnchor.constraint(equalToConstant: UIConstants.Spacing.thumbnailSize),

            vStack.leadingAnchor.constraint(equalTo: thumb.trailingAnchor, constant: UIConstants.Spacing.edgeInset),
            vStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            vStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with article: Article) {
            titleLabel.text = article.title
            bylineLabel.text = article.byline
            dateLabel.text = article.publishedDate
            
            let placeholder = UIImage(systemName: AppConstants.Images.placeholder)
            if let urlString = article.media.first?.mediaMetadata.last?.url,
               let url = URL(string: urlString) {
                thumb.setImage(from: url, placeholder: placeholder)
            } else {
                thumb.image = placeholder
            }
        }
}
