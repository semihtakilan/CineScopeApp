//
//  FirestoreManager.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 6.05.2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine
import SwiftUI

class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    @Published var favoriteMovies: [Movie] = []
    @Published var watchlistMovies: [Movie] = []
    @Published var isLoading: Bool = false
    
    private init() {
        fetchFavorites()
        fetchWatchlist()
    }
    
    // MARK: - 1. EKLEME
    func addToFavorites(movie: Movie) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").document(uid).collection("favorites").document("\(movie.id)")
        
        let data: [String: Any] = ["id": movie.id]
        
        docRef.setData(data) { _ in self.fetchFavorites() }
    }
    
    func addToWatchlist(movie: Movie) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").document(uid).collection("watchlist").document("\(movie.id)")
        
        let data: [String: Any] = ["id": movie.id]
        
        docRef.setData(data) { _ in self.fetchWatchlist() }
    }

    // MARK: - 2. GETİRME
    func fetchFavorites() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        DispatchQueue.main.async { self.isLoading = true }
        
        db.collection("users").document(uid).collection("favorites").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let ids = documents.compactMap { $0.data()["id"] as? Int }
            self.fetchMoviesFromAPI(ids: ids) { movies in
                DispatchQueue.main.async {
                    self.favoriteMovies = movies
                    self.isLoading = false
                }
            }
        }
    }
    
    func fetchWatchlist() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).collection("watchlist").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let ids = documents.compactMap { $0.data()["id"] as? Int }
            self.fetchMoviesFromAPI(ids: ids) { movies in
                DispatchQueue.main.async {
                    self.watchlistMovies = movies
                }
            }
        }
    }

    // MARK: - 3. YARDIMCI: ID Listesini Movie Nesnelerine Dönüştürme
    private func fetchMoviesFromAPI(ids: [Int], completion: @escaping ([Movie]) -> Void) {
        if ids.isEmpty { completion([]); return }
        
        let group = DispatchGroup()
        var fetchedMovies: [Movie] = []
        
        for id in ids {
            group.enter()
            NetworkManager.shared.fetchMovieDetails(movieID: id) { detail in
                if let detail = detail {
                    let movie = Movie(
                        id: detail.id,
                        title: detail.title,
                        overview: detail.overview,
                        voteAverage: detail.voteAverage,
                        posterPath: detail.posterPath
                    )
                    fetchedMovies.append(movie)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(fetchedMovies)
        }
    }
    
    func removeFromFavorites(movie: Movie) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("favorites").document("\(movie.id)").delete { _ in self.fetchFavorites() }
    }
    
    func removeFromWatchlist(movie: Movie) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("watchlist").document("\(movie.id)").delete { _ in self.fetchWatchlist() }
    }
    
    func isFavorite(movie: Movie) -> Bool { favoriteMovies.contains(where: { $0.id == movie.id }) }
    func isInWatchlist(movie: Movie) -> Bool { watchlistMovies.contains(where: { $0.id == movie.id }) }
    
    func clearData() {
        DispatchQueue.main.async {
            self.favoriteMovies = []
            self.watchlistMovies = []
            self.isLoading = false
        }
    }
}


