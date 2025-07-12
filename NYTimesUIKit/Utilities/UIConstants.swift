//
//  UIConstants.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//


import UIKit

enum UIConstants {
    
    enum Cell {
        static let articleReuseIdentifier = "ArticleCell"
    }
    
    enum Layout {
        static let interItemSpacing: CGFloat = 8
        static let sectionInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        static let thumbnailAspectRatio: CGFloat = 16/9
    }

    enum Spacing {
        static let edgeInset: CGFloat = 16
        static let thumbnailSize: CGFloat = 60
        static let stackSpacing: CGFloat = 4
        static let contentSpacing: CGFloat = 12
    }

    enum Colors {
        static let background = UIColor.systemGroupedBackground
        static let primaryText = UIColor.label
        static let secondaryText = UIColor.secondaryLabel
        static let tertiaryFill = UIColor.tertiarySystemFill
    }

    enum Fonts {
        static let headline = UIFont.preferredFont(forTextStyle: .headline)
        static let title1 = UIFont.preferredFont(forTextStyle: .title1)
        static let title2 = UIFont.preferredFont(forTextStyle: .title2)
        static let subheadline = UIFont.preferredFont(forTextStyle: .subheadline)
        static let body = UIFont.preferredFont(forTextStyle: .body)
        static let caption1 = UIFont.preferredFont(forTextStyle: .caption1)
    }
}
