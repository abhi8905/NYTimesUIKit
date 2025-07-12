//
//  UIImageView+ImageCache.swift.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 11/07/2025.
//


import NYTKit
import UIKit

extension UIImageView {
    @MainActor
    func setImage(from url: URL,
                  placeholder: UIImage? = nil,
                  cache: ImageCacheProtocol = ImageCache.shared,
                  session: URLSession = .shared) {
        self.image = placeholder

        Task {
            if let cachedImage = await cache.get(forKey: url.absoluteString) {
                self.image = cachedImage
                return
            }

            do {
                let (data, _) = try await session.data(from: url)
                if let downloadedImage = UIImage(data: data) {
                    await cache.set(downloadedImage, forKey: url.absoluteString)
                    self.image = downloadedImage
                }
            } catch {
                print("Image download failed for \(url): \(error)")
            }
        }
    }
}
