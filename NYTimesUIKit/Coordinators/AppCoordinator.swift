//
//  AppCoordinator.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//


import UIKit
import NYTKit

final class AppCoordinator: BaseCoordinator {
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        navigationController.delegate = self
    }

    @MainActor
    override func start() {
        let listCoordinator = ArticleListCoordinator(navigationController: navigationController)
        listCoordinator.delegate = self
        addChild(listCoordinator)
        listCoordinator.start()
    }
}

// MARK: - ParentCoordinator

extension AppCoordinator: ParentCoordinator {
    func childDidFinish(_ child: Coordinator) {
        removeChild(child)
    }
}

// MARK: - ArticleListCoordinatorDelegate

extension AppCoordinator: ArticleListCoordinatorDelegate {
    @MainActor
    func coordinator(_ coordinator: ArticleListCoordinator, didSelect article: Article) {
        let detailCoordinator = ArticleDetailCoordinator(
            navigationController: navigationController,
            article: article
        )
        addChild(detailCoordinator)
        detailCoordinator.start()
    }
}

// MARK: - UINavigationControllerDelegate (Pop Detection)

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard
            let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromVC)
        else { return }

        if let popped = findCoordinator(owning: fromVC, in: childCoordinators) {
            popped.finish()
        }
    }

    private func findCoordinator(
        owning vc: UIViewController,
        in list: [Coordinator]
    ) -> Coordinator? {
        for coord in list {
            if coord.rootViewController === vc {
                return coord
            }
            if let nested = findCoordinator(owning: vc, in: coord.childCoordinators) {
                return nested
            }
            }
        return nil
    }
}
