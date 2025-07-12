//
//  UIImageView.swift
//  NYTimesUIKit
//
//  Created by Abhinav Jha on 12/07/2025.
//


import XCTest
@testable import NYTimesUIKit
@testable import NYTKit


final class UIImageView_ImageCacheTests: XCTestCase {
    @MainActor
    func test_setImage_usesCachedImageIfAvailable() async throws {
        let url = URL(string: "https://example.com/sample.png")!
        let dummyImage = UIImage(systemName: "checkmark.circle")!
        let mockCache = MockImageCache()
        mockCache.storedImages[url.absoluteString] = dummyImage

        let imageView = UIImageView()
        imageView.setImage(from: url, placeholder: nil, cache: mockCache)

        try await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertEqual(imageView.image, dummyImage)
        XCTAssertEqual(mockCache.getCalledKey, url.absoluteString)
    }
}

@MainActor
final class MockImageCache: ImageCacheProtocol {
    var storedImages: [String: UIImage] = [:]
    var getCalledKey: String?

    func set(_ image: UIImage, forKey key: String) async {
        storedImages[key] = image
    }

    func get(forKey key: String) async -> UIImage? {
        getCalledKey = key
        return storedImages[key]
    }

    func clear() async {
        storedImages.removeAll()
    }
}
