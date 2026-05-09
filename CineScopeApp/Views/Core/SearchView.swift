//
//  SearchView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    let imageBaseURL = "https://image.tmdb.org/t/p/w200"
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Aranıyor...")
                } else if viewModel.searchResults.isEmpty && !viewModel.searchQuery.isEmpty {
                    Text("Sonuç bulunamadı.")
                        .foregroundColor(.secondary)
                } else if viewModel.searchResults.isEmpty && viewModel.searchQuery.isEmpty {
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.bottom, 10)
                        Text("Film aramaya başlayın")
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.searchResults) { movie in
                                NavigationLink(destination: MovieDetailView(movieId: movie.id, initialTitle: movie.title)) {
                                    
                                    // Yatay Arama Sonucu Kartı
                                    HStack(alignment: .top, spacing: 15) {
                                        // Poster
                                        if let posterPath = movie.posterPath, let url = URL(string: imageBaseURL + posterPath) {
                                            AsyncImage(url: url) { phase in
                                                if let image = phase.image {
                                                    image.resizable().aspectRatio(contentMode: .fill)
                                                } else {
                                                    Color.gray.opacity(0.3)
                                                }
                                            }
                                            .frame(width: 80, height: 120)
                                            .cornerRadius(8)
                                        } else {
                                            Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 80, height: 120).cornerRadius(8)
                                        }
                                        
                                        // Bilgiler
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(movie.title)
                                                .font(.headline)
                                                .multilineTextAlignment(.leading)
                                            
                                            HStack {
                                                Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                                                Text(String(format: "%.1f", movie.voteAverage))
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                            }
                                            
                                            Text(movie.overview)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .lineLimit(3)
                                                .multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Arama")
            .searchable(text: $viewModel.searchQuery, prompt: "Film ara...")
        }
    }
}
