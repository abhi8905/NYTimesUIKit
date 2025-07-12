//
//  ArticleListCoordinator.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//

import UIKit
import NYTKit

@MainActor
protocol ArticleListCoordinatorDelegate: AnyObject {
    func coordinator(_ coordinator: ArticleListCoordinator, didSelect article: Article)
}

final class ArticleListCoordinator: BaseCoordinator {

    weak var delegate: ArticleListCoordinatorDelegate?

    @MainActor
    override func start() {
        let repository = NYTArticlesRepository()
        let viewModel = ArticleListViewModel(
            repository: repository,
            networkMonitor: NetworkMonitor.shared
        )

        let listVC = ArticleListViewController(viewModel: viewModel) { [weak self] article in
            guard let self = self else { return }
            self.delegate?.coordinator(self, didSelect: article)
        }

        rootViewController = listVC
        
        navigationController.setViewControllers([listVC], animated: false)
    }
}

extension ArticleListCoordinator: ParentCoordinator {
    func childDidFinish(_ child: Coordinator) {
        removeChild(child)
    }
}
