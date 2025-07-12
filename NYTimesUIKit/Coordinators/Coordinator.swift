//
//  Coordinator.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//


import UIKit

/// Notifies a parent coordinator that one of its child coordinators has finished.
protocol ParentCoordinator: AnyObject {
    func childDidFinish(_ child: Coordinator)
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }

    var childCoordinators: [Coordinator] { get set }

    var parentCoordinator: ParentCoordinator? { get set }

    var rootViewController: UIViewController? { get set }

    @MainActor func start()

    func finish()
}

extension Coordinator {
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }

    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self as? ParentCoordinator
    }

    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
