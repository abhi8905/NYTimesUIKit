//
//  ArticleDetailCoordinatorTests.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 12/07/2025.
//


import XCTest
@testable import NYTimesUIKit
import NYTKit

final class ArticleDetailCoordinatorTests: XCTestCase {
    private var navController: SpyNavigationController!
    private var article: Article!
    private var coordinator: ArticleDetailCoordinator!

    override func setUp() {
        super.setUp()
        navController = SpyNavigationController()
        article = Article(
            id: 42,
            url: "https://example.com",
            publishedDate: "2025-07-12",
            byline: "Test Author",
            title: "Test Article",
            abstract: "A test abstract.",
            media: [],
            section: "Test"
        )
        coordinator = ArticleDetailCoordinator(navigationController: navController, article: article)
    }

    @MainActor
    func testStartPushesArticleDetailViewController() {
        coordinator.start()

        XCTAssertEqual(navController.pushedViewControllers.count, 1)

        let pushedVC = navController.pushedViewControllers.first
        XCTAssertTrue(pushedVC is ArticleDetailViewController)
    }
}