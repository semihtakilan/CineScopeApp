//
//  ImageCache.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 7.05.2026.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func set(forKey key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
