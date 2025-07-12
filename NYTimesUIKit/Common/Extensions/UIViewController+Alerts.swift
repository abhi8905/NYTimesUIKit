//
//  UIView+Constraints.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//

import UIKit

extension UIViewController {
    /// Present a simple one-button alert on the main thread.
    func showAlert(
        title: String = "Error",
        message: String,
        buttonTitle: String = "OK"
    ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            )
            self.present(alert, animated: true, completion: nil)
        }
    }
}
