//
//  MovieDetailView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    let initialTitle: String
    
    @StateObject private var viewModel = MovieDetailViewModel()
    @ObservedObject var firestoreManager = FirestoreManager.shared
    
    let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    let profileBaseURL = "https://image.tmdb.org/t/p/w200"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.isLoading {
                ProgressView("Detaylar Yükleniyor...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 200)
            } else if let details = viewModel.movieDetails {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: - 1. AFİŞ KISMI
                    GeometryReader { geo in
                        ZStack(alignment: .bottomLeading) {
                            if let backdropPath = details.backdropPath, let url = URL(string: imageBaseURL + backdropPath) {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: geo.size.width, height: 280)
                                            .clipped()
                                    } else {
                                        Rectangle().fill(Color.gray.opacity(0.3))
                                    }
                                }
                            } else {
                                Rectangle().fill(Color.gray.opacity(0.3))
                            }
                            
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                                startPoint: .bottom,
                                endPoint: .center
                            )
                        }
                    }
                    .frame(height: 280)
                    
                    // MARK: - 2. İÇERİK KISMI
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // --- BAŞLIK VE TÜRLER (Tam Genişlik) ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text(details.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack {
                                Text(details.year)
                                Text("•")
                                Text(details.formattedRuntime)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                            if let genres = details.genres {
                                Text(genres.map { $0.name }.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack {
                            // Sol: Puan
                            HStack(spacing: 12) {
                                CircularProgressView(voteAverage: details.voteAverage)
                                    .scaleEffect(1.1)
                                
                                Text("Kullanıcı\nPuanı")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            // Sağ: Butonlar (Minimalist tasarım)
                            HStack(spacing: 15) {
                                
                                // FAVORİ BUTONU
                                Button(action: {
                                    let tempMovie = Movie(
                                        id: details.id,
                                        title: details.title,
                                        overview: details.overview,
                                        voteAverage: details.voteAverage,
                                        posterPath: details.posterPath
                                    )
                                    if firestoreManager.isFavorite(movie: tempMovie) {
                                        firestoreManager.removeFromFavorites(movie: tempMovie)
                                    } else {
                                        firestoreManager.addToFavorites(movie: tempMovie)
                                    }
                                }) {
                                    let tempMovie = Movie(id: details.id, title: "", overview: "", voteAverage: 0, posterPath: nil)
                                    
                                    Image(systemName: firestoreManager.isFavorite(movie: tempMovie) ? "heart.fill" : "heart")
                                        .font(.title3) // Boyutu eşitledik
                                        .frame(width: 44, height: 44) // Aynı çerçeve
                                        .background(Color.secondary.opacity(0.15)) // Aynı hover arka planı
                                        .foregroundColor(firestoreManager.isFavorite(movie: tempMovie) ? .red : .primary)
                                        .clipShape(Circle()) // Aynı yuvarlak kesim
                                }
                                
                                // İZLEME LİSTESİ BUTONU
                                Button(action: {
                                    let tempMovie = Movie(
                                        id: details.id,
                                        title: details.title,
                                        overview: details.overview,
                                        voteAverage: details.voteAverage,
                                        posterPath: details.posterPath
                                    )
                                    if firestoreManager.isInWatchlist(movie: tempMovie) {
                                        firestoreManager.removeFromWatchlist(movie: tempMovie)
                                    } else {
                                        firestoreManager.addToWatchlist(movie: tempMovie)
                                    }
                                }) {
                                    let tempMovie = Movie(id: details.id, title: "", overview: "", voteAverage: 0, posterPath: nil)
                                    
                                    Image(systemName: firestoreManager.isInWatchlist(movie: tempMovie) ? "bookmark.fill" : "bookmark")
                                        .font(.title3)
                                        .frame(width: 44, height: 44)
                                        .background(Color.secondary.opacity(0.15))
                                        .foregroundColor(firestoreManager.isInWatchlist(movie: tempMovie) ? .blue : .primary)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding(.vertical, 5)
                        
                        // --- Özet ---
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Özet")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Text(details.overview.isEmpty ? "Özet bulunmuyor." : details.overview)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                            
                            Divider().padding(.vertical, 5)
                            
                            // Ekip (Yönetmen & Senarist)
                            HStack(alignment: .top, spacing: 40) {
                                if let director = viewModel.director {
                                    VStack(alignment: .leading) {
                                        Text(director.name).fontWeight(.bold)
                                        Text("Yönetmen").font(.caption).foregroundColor(.secondary)
                                    }
                                }
                                
                                if let writer = viewModel.writers.first {
                                    VStack(alignment: .leading) {
                                        Text(writer.name).fontWeight(.bold)
                                        Text(LocalizedStringKey(writer.job == "Screenplay" || writer.job == "Writer" ? "Senarist" : writer.job))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        
                        // --- Oyuncu Kadrosu ---
                        if let cast = details.credits?.cast, !cast.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Oyuncu Kadrosu")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(cast.prefix(15)) { actor in
                                            NavigationLink(destination: PersonDetailView(personId: actor.id)) {
                                                VStack {
                                                    if let profilePath = actor.profilePath, let url = URL(string: profileBaseURL + profilePath) {
                                                        AsyncImage(url: url) { phase in
                                                            if let image = phase.image {
                                                                image.resizable().aspectRatio(contentMode: .fill)
                                                            } else {
                                                                Color.gray.opacity(0.3)
                                                            }
                                                        }
                                                        .frame(width: 100, height: 140)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    } else {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(Color.gray.opacity(0.3))
                                                            .frame(width: 100, height: 140)
                                                            .overlay(Image(systemName: "person.fill").foregroundColor(.gray))
                                                    }
                                                    
                                                    Text(actor.name)
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                        .lineLimit(1)
                                                    Text(actor.character)
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                        .lineLimit(1)
                                                }
                                                .frame(width: 100)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                                .padding(.horizontal, -20)
                                .padding(.leading, 20)
                            }
                        }
                        
                        // BENZER FİLMLER
                        if let similarMovies = details.similar?.results, !similarMovies.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Divider().padding(.vertical, 5)
                                
                                Text("Benzer Filmler:")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(similarMovies) { movie in
                                            NavigationLink(destination: MovieDetailView(movieId: movie.id, initialTitle: movie.title)) {
                                                MovieCardView(movie: movie)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                                .padding(.horizontal, -20)
                                .padding(.leading, 20)
                            }
                            .padding(.top, 10)
                        }
                        
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            viewModel.getDetails(id: movieId)
        }
    }
}
