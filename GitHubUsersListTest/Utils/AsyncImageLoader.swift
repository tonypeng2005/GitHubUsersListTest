//
//  AsyncImageLoader.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/16.
//

import Combine
import UIKit

class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var cancellable: AnyCancellable?
    
    func loadImage(from url: URL) {
        // Check if image is cached
        if let cachedImage = ImageCache.shared.get(forKey: url) {
            self.image = cachedImage
            return
        }
        
        // Otherwise, download the image
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                if let image = downloadedImage {
                    // Cache the image
                    ImageCache.shared.set(image, forKey: url)
                }
                self?.image = downloadedImage
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
