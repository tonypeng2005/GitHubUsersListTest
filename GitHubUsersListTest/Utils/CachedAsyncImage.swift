//
//  CachedAsyncImage.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/16.
//

import SwiftUI

struct CachedAsyncImage: View {
    @StateObject private var loader: AsyncImageLoader
    private let placeholder: Image
    private let url: URL
    
    init(url: URL, placeholder: Image = Image(systemName: "person.crop.circle.fill")) {
        self.url = url
        self.placeholder = placeholder
        _loader = StateObject(wrappedValue: AsyncImageLoader())
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder
                    .resizable()
            }
        }
        .onAppear {
            loader.loadImage(from: url)
        }
        .onDisappear {
            loader.cancel()
        }
    }
}
