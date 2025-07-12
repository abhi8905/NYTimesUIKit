//
//  AppCoordinatorTests.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 12/07/2025.
//


import XCTest
@testable import NYTimesUIKit
import NYTKit

final class AppCoordinatorTests: XCTestCase {
    var navController: UINavigationController!
    var coordinator: AppCoordinator!

    override func setUp() {
        super.setUp()
        navController = UINavigationController()
        coordinator = AppCoordinator(navigationController: navController)
    }

    override func tearDown() {
        navController = nil
        coordinator = nil
        super.tearDown()
    }

    @MainActor
    func testStartAddsArticleListCoordinator() {
        coordinator.start()

        let isDelegateCorrect = navController.delegate === coordinator
        XCTAssertTrue(isDelegateCorrect)

        XCTAssertEqual(coordinator.childCoordinators.count, 1)
        XCTAssertTrue(coordinator.childCoordinators.first is ArticleListCoordinator)
    }

    func testChildDidFinishRemovesCoordinator() {
        let dummy = DummyCoordinator(navigationController: navController)
        coordinator.addChild(dummy)
        XCTAssertEqual(coordinator.childCoordinators.count, 1)

        coordinator.childDidFinish(dummy)

        XCTAssertEqual(coordinator.childCoordinators.count, 0)
    }
}

// MARK: - DummyCoordinator

final class DummyCoordinator: BaseCoordinator {
    var finishedCalled = false

    override func finish() {
        finishedCalled = true
        super.finish()
    }
}
