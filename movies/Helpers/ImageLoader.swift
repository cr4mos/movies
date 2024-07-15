//
//  ImageLoader.swift
//  movies
//
//  Created by Carlos Ramos on 15/07/24.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func load() {
        if let cachedImage = ImageCache.shared.image(for: url) {
            image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let uiImage = UIImage(data: data)
            else {
                return
            }

            DispatchQueue.main.async {
                ImageCache.shared.setImage(uiImage, for: self.url)
                self.image = uiImage
            }
        }.resume()
    }
}
