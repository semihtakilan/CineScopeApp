//
//  FavoritesView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 6.05.2026.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if firestoreManager.favoriteMovies.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("Henüz Favorin Yok")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Keşfetmeye başla ve sevdiğin filmleri buraya ekle!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(firestoreManager.favoriteMovies) { movie in
                                NavigationLink(destination: MovieDetailView(movieId: movie.id, initialTitle: movie.title)) {
                                    MovieCardView(movie: movie)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorilerim")
        }
    }
}
