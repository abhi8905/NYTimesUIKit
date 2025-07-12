//
//  ArticleListCoordinatorTests.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 12/07/2025.
//


import XCTest
@testable import NYTimesUIKit
import NYTKit

final class ArticleListCoordinatorTests: XCTestCase {
    var navController: SpyNavigationController!
    var coordinator: ArticleListCoordinator!
    var parent: MockParentCoordinator!

    override func setUp() {
        super.setUp()
        navController = SpyNavigationController()
        coordinator = ArticleListCoordinator(navigationController: navController)
        parent = MockParentCoordinator()
        coordinator.parentCoordinator = parent
    }

    @MainActor
    func testStartPushesArticleListViewController() {
        coordinator.start()

        XCTAssertEqual(navController.viewControllers.count, 1)
        XCTAssertTrue(navController.viewControllers.first is ArticleListViewController)
    }

    @MainActor
    func testArticleSelectionTriggersParentCallback() {
        let navController = SpyNavigationController()
        let coordinator = ArticleListCoordinator(navigationController: navController)

        let parent = MockParent()
        coordinator.delegate = parent

        coordinator.start()

        guard let listVC = navController.viewControllers.first as? ArticleListViewController else {
            XCTFail("Expected ArticleListViewController to be pushed")
            return
        }

        let testArticle = Article(id: 99, url: "", publishedDate: "", byline: "", title: "", abstract: "", media: [], section: "")
        listVC.onArticleSelected(testArticle)

        XCTAssertEqual(parent.selectedArticle?.id, 99)
    }
    
    func testFinishRemovesFromParent() {
        coordinator.finish()

        XCTAssertTrue(parent.didFinishCalled)
    }
    
    func testChildDidFinishRemovesCoordinator() {
        let nav = UINavigationController()
        let coordinator = ArticleListCoordinator(navigationController: nav)

        let dummyChild = DummyCoordinator(navigationController: nav)
        coordinator.addChild(dummyChild)

        XCTAssertTrue(coordinator.childCoordinators.contains(where: { $0 === dummyChild }))

        coordinator.childDidFinish(dummyChild)

        XCTAssertFalse(coordinator.childCoordinators.contains(where: { $0 === dummyChild }))
    }
}

final class SpyNavigationController: UINavigationController {
    var pushedViewControllers: [UIViewController] = []

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: false)
    }
}

final class MockParentCoordinator: ParentCoordinator {
    var didFinishCalled = false
    var selectedArticle: Article?

    func childDidFinish(_ child: Coordinator) {
        didFinishCalled = true
    }
}

final class MockParent: ArticleListCoordinatorDelegate {
    var selectedArticle: Article?

    func coordinator(_ coordinator: ArticleListCoordinator, didSelect article: Article) {
        selectedArticle = article
    }
}
