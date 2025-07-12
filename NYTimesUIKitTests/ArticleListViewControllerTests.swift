//
//  ArticleListViewControllerTests.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 12/07/2025.
//


import XCTest
@testable import NYTimesUIKit
@testable import NYTKit
import Combine
import UIKit

@MainActor
final class ArticleListViewControllerTests: XCTestCase {
    var viewModel: MockArticleListViewModel!
    var sut: ArticleListViewController!
    var selectedArticle: Article?
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = MockArticleListViewModel()

        sut = ArticleListViewController(
            viewModel: viewModel,
            onArticleSelected: { [weak self] article in
                self?.selectedArticle = article
            },
            dataSourceFactory: { collectionView in
                let ds = UICollectionViewDiffableDataSource<ArticleListViewController.Section, Article>(
                    collectionView: collectionView
                ) { cv, indexPath, article in
                    let cell = UICollectionViewCell()
                    cell.accessibilityIdentifier = "ArticleCell_\(article.id)"
                    return cell
                }
                return ds
            }
        )

        _ = sut.view
    }

    func testRendersLoadingState() {
        viewModel.state = .loading
        sut.render(.loading)

        let indicatorVisible = sut.view.subviews.contains {
            ($0 as? UIActivityIndicatorView)?.isAnimating == true
        }

        XCTAssertTrue(indicatorVisible)
    }

    @MainActor
    func testRendersSuccessStateWithArticles() {
        let article = Article(id: 1, url: "", publishedDate: "", byline: "", title: "Test", abstract: "", media: [], section: "")
        viewModel.state = .success([article])
        sut.render(.success([article]))

        let snapshot = sut.dataSource.snapshot()
        XCTAssertEqual(snapshot.itemIdentifiers.count, 1)
        XCTAssertEqual(snapshot.itemIdentifiers.first?.id, article.id)
    }

    func testRendersFailureWithRetry() {
        viewModel.state = .failure("Network error")
        sut.render(.failure("Network error"))

        let emptyView = sut.view.subviews
            .compactMap { $0 as? EmptyStateView }
            .first

        emptyView?.retryAction?()

        XCTAssertTrue(viewModel.updateFilterCalled)
    }

    func testCellTapTriggersSelection() {
        let article = Article(id: 42, url: "", publishedDate: "", byline: "", title: "Test", abstract: "", media: [], section: "")
        viewModel.state = .success([article])
        sut.render(.success([article]))

        sut.collectionView.delegate?.collectionView?(
            sut.collectionView,
            didSelectItemAt: IndexPath(item: 0, section: 0)
        )

        XCTAssertEqual(selectedArticle?.id, 42)
    }
}

final class MockArticleListViewModel: ArticleListViewModelProtocol {
    @Published var state: ViewState = .idle
    @Published var filter: MostPopularFilter = .init(endpoint: .viewed, period: .day)

    var updateFilterCalled = false

    var statePublisher: Published<ViewState>.Publisher { $state }
    var filterPublisher: Published<MostPopularFilter>.Publisher { $filter }

    func updateFilter(endpoint: MostPopularFilter.EndpointType?, period: MostPopularFilter.Period?) {
        updateFilterCalled = true
    }
}
