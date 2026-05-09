//
//  HomeViewModel.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var categories: [MovieCategory] = []
    @Published var isLoading: Bool = false
    @AppStorage("app_language") private var appLanguage = "tr"
    
    init() {
        fetchAllCategories()
    }
    
    func fetchAllCategories() {
        isLoading = true
        
        let group = DispatchGroup()
        
        var popularMovies: [Movie] = []
        var upcomingMovies: [Movie] = []
        var topRatedMovies: [Movie] = []
        
        // 1. İSTEK: Popüler Filmler
        group.enter()
        NetworkManager.shared.fetchMovies(from: .popular) { movies in
            popularMovies = movies ?? []
            group.leave()
        }
        
        // 2. İSTEK: Yakında Gelecekler
        group.enter()
        NetworkManager.shared.fetchMovies(from: .upcoming) { movies in
            upcomingMovies = movies ?? []
            group.leave()
        }
        
        // 3. İSTEK: En Çok Oy Alanlar
        group.enter()
        NetworkManager.shared.fetchMovies(from: .topRated) { movies in
            topRatedMovies = movies ?? []
            group.leave()
        }
        
        // TÜM İŞLER BİTİNCE
        group.notify(queue: .main) { [weak self] in
            let cat1 = MovieCategory(title: "Popüler", movies: popularMovies)
            let cat2 = MovieCategory(title: "Yakında Sinemalarda", movies: upcomingMovies)
            let cat3 = MovieCategory(title: "Efsaneler", movies: topRatedMovies)
            
            self?.categories = [cat1, cat2, cat3]
            self?.isLoading = false
        }
    }
}
