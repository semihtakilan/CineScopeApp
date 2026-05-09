//
//  ContentView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @AppStorage("app_language") private var appLanguage = "tr"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    ProgressView("Filmler Yükleniyor...")
                        .scaleEffect(1.2)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 25) {
                            
                            ForEach(viewModel.categories, id: \.id) { category in
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    // 1. Kategori Başlığı (Örn: Popüler)
                                    Text(category.title)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                    
                                    // 2. O Kategoriye Ait Yatay Kaydırma Alanı
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        
                                        HStack(spacing: 16) {
                                            ForEach(category.movies) { movie in
                                                NavigationLink(destination: MovieDetailView(movieId: movie.id, initialTitle: movie.title)) {
                                                    MovieCardView(movie: movie)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("CineScope")
        }
        
        .onChange(of: appLanguage) {
            viewModel.fetchAllCategories()
        }
    }
}

#Preview {
    ContentView()
}
