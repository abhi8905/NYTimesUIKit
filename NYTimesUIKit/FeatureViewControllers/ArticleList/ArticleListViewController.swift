//
//  ArticleListViewController.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//

import UIKit
import NYTKit
import Combine

final class ArticleListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: any ArticleListViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let emptyView = EmptyStateView()
    private let dataSourceFactory: (UICollectionView) -> UICollectionViewDiffableDataSource<Section, Article>
    var dataSource: UICollectionViewDiffableDataSource<Section, Article>!
    var collectionView: UICollectionView!


    enum Section { case main }

    public let onArticleSelected: (Article) -> Void

    // MARK: - Init
    init(viewModel: any ArticleListViewModelProtocol,
         onArticleSelected: @escaping (Article) -> Void,
         dataSourceFactory: @escaping (UICollectionView) -> UICollectionViewDiffableDataSource<Section, Article> = ArticleListViewController.defaultDataSourceFactory) {
        self.viewModel = viewModel
        self.onArticleSelected = onArticleSelected
        self.dataSourceFactory = dataSourceFactory
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        view.backgroundColor = UIConstants.Colors.background
        setupCollectionView()
        setupActivityIndicator()
        setupEmptyView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if case .idle = viewModel.state {
            viewModel.resetFilter()
        }
    }

    // MARK: - Setup
    private func configureNavigationBar() {
        navigationItem.title = AppConstants.Titles.articleList
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: AppConstants.Images.filterIcon),
            menu: makeFilterMenu()
        )
    }
    
    private func setupCollectionView() {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.showsSeparators = true
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            ArticleCell.self,
            forCellWithReuseIdentifier: UIConstants.Cell.articleReuseIdentifier
        )
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.pinEdges(to: view)
        
        dataSource = dataSourceFactory(collectionView)
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupEmptyView() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: UIConstants.Spacing.edgeInset),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -UIConstants.Spacing.edgeInset)
        ])
    }

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.filterPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationItem.rightBarButtonItem?.menu = self?.makeFilterMenu()
            }
            .store(in: &cancellables)
            
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Render
    func render(_ state: ViewState) {
        collectionView.isHidden = true
        activityIndicator.stopAnimating()
        emptyView.isHidden = true

        switch state {
        case .idle, .loading:
            activityIndicator.startAnimating()

        case .success(let articles):
            collectionView.isHidden = false
            var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
            snapshot.appendSections([.main])
            snapshot.appendItems(articles, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: false)

        case .offline:
            emptyView.isHidden = false
            emptyView.configure(
                title: AppConstants.OfflineMessages.title,
                message: AppConstants.OfflineMessages.title,
                systemImageName: AppConstants.Images.offline
            )

        case .failure(let message):
            emptyView.isHidden = false
            emptyView.configure(
                title: AppConstants.ErrorMessages.genericTitle,
                message: message,
                systemImageName: AppConstants.Images.error,
                retryHandler: { [weak self] in
                    self?.viewModel.resetFilter()
                }
            )
        }
    }
    
    static func defaultDataSourceFactory(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Article> {
        UICollectionViewDiffableDataSource<Section, Article>(
            collectionView: collectionView
        ) { cv, ip, article in
            let cell = cv.dequeueReusableCell(
                withReuseIdentifier: UIConstants.Cell.articleReuseIdentifier,
                for: ip
            ) as! ArticleCell
            cell.configure(with: article)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ArticleListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let article = dataSource.itemIdentifier(for: indexPath) {
            onArticleSelected(article)
        }
    }
}

// MARK: - Menu Builder
private extension ArticleListViewController {
    func makeFilterMenu() -> UIMenu {
        let currentFilter = viewModel.filter
        
        let endpointActions = MostPopularFilter.EndpointType.allCases.map { type in
            UIAction(
                title: type.rawValue.capitalized,
                state: type == currentFilter.endpoint ? .on : .off
            ) { [weak self] _ in
                self?.viewModel.updateFilter(endpoint: type, period: nil)
            }
        }
        let endpointMenu = UIMenu(title: AppConstants.Filters.endpointMenuTitle, options: .displayInline, children: endpointActions)

        let periodActions = MostPopularFilter.Period.allCases.map { period in
            UIAction(
                title: period.displayName,
                state: period == currentFilter.period ? .on : .off
            ) { [weak self] _ in
                self?.viewModel.updateFilter(endpoint: nil, period: period)
            }
        }
        let periodMenu = UIMenu(title: AppConstants.Filters.periodMenuTitle, options: .displayInline, children: periodActions)

        return UIMenu(title: "", children: [endpointMenu, periodMenu])
    }
}
