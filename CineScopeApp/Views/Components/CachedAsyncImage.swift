//
//  CachedAsyncImage.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 7.05.2026.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var uiImage: UIImage? = nil
    
    init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let uiImage = uiImage {
            content(Image(uiImage: uiImage))
        } else {
            placeholder()
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        let urlString = url.absoluteString
        
        if let cachedImage = ImageCache.shared.get(forKey: urlString) {
            self.uiImage = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                
                ImageCache.shared.set(forKey: urlString, image: downloadedImage)
                
                DispatchQueue.main.async {
                    self.uiImage = downloadedImage
                }
            }
        }.resume()
    }
}
