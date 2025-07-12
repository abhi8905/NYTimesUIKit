//
//  ArticleDetailViewController.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//


import UIKit
import NYTKit

final class ArticleDetailViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ArticleDetailViewModel
    
    // MARK: - UI Components (as Lazy Factories)
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            imageView, textStackView
        ])
        stack.axis = .vertical
        stack.spacing = UIConstants.Spacing.contentSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel, abstractLabel, separator, tagDateStack, bylineLabel, linkButton
        ])
        stack.axis = .vertical
        stack.spacing = UIConstants.Spacing.contentSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: UIConstants.Spacing.edgeInset, bottom: 0, right: UIConstants.Spacing.edgeInset)
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16)
        ])
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.title1
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var abstractLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.body
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1)
        ])
        return view
    }()
    
    private lazy var tagDateStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tagLabel, UIView(), dateLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()

    private lazy var tagLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = UIConstants.Fonts.caption1
        label.textColor = UIConstants.Colors.secondaryText
        label.backgroundColor = UIConstants.Colors.tertiaryFill
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Fonts.subheadline
        label.textColor = UIConstants.Colors.secondaryText
        return label
    }()

    private lazy var bylineLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: UIConstants.Fonts.subheadline.pointSize)
        label.textColor = UIConstants.Colors.secondaryText
        label.numberOfLines = 0
        return label
    }()

    private lazy var linkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppConstants.Links.title, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(didTapLink), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializer
    init(viewModel: ArticleDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configure()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = AppConstants.Titles.detailTitle
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonDisplayMode = .minimal
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configure() {
        titleLabel.text = viewModel.titleText
        abstractLabel.text = viewModel.abstractText
        tagLabel.text = viewModel.sectionText
        dateLabel.text = viewModel.publishedDateString
        bylineLabel.text = viewModel.bylineText

        if let url = viewModel.imageURL {
            imageView.setImage(from: url)
        }

        linkButton.isHidden = (viewModel.articleURL == nil)
    }

    // MARK: - Actions
    @objc private func didTapLink() {
        guard let url = viewModel.articleURL else { return }
        UIApplication.shared.open(url)
    }
}
