//
//  ImageCache.swift
//  movies
//
//  Created by Carlos Ramos on 15/07/24.
//

import SwiftUI

final class ImageCache: ObservableObject {
    static let shared = ImageCache()

    @Published private(set) var cache: [URL: UIImage] = [:]

    private init() {}

    func image(for url: URL) -> UIImage? {
        return cache[url]
    }

    func setImage(_ image: UIImage, for url: URL) {
        cache[url] = image
    }
}

