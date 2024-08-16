//
//  ImageCache.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/16.
//

import Foundation
import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSURL, UIImage>()
    
    func get(forKey key: URL) -> UIImage? {
        return cache.object(forKey: key as NSURL)
    }
    
    func set(_ image: UIImage, forKey key: URL) {
        cache.setObject(image, forKey: key as NSURL)
    }
}
