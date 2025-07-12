//
//  ArticleDetailCoordinator.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//

import UIKit
import NYTKit

final class ArticleDetailCoordinator: BaseCoordinator {
    private let article: Article

    init(navigationController: UINavigationController, article: Article) {
        self.article = article
        super.init(navigationController: navigationController)
    }

    @MainActor
    override func start() {
        let viewModel = ArticleDetailViewModel(article: article)
        let detailVC = ArticleDetailViewController(viewModel: viewModel)
        
        rootViewController = detailVC


        navigationController.pushViewController(detailVC, animated: true)
    }

    override func finish() {
        parentCoordinator?.childDidFinish(self)
    }
}
