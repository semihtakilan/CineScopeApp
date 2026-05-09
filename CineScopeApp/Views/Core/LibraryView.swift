//
//  LibraryView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 6.05.2026.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    
    @AppStorage("app_language") private var appLanguage = "tr"
    
    @State private var selectedTab = "Favorilerim"
    let tabs = ["Favorilerim", "İzleme Listem"]
    
    @Namespace private var animation
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: - MODERN YATAY SLIDER (TAB BAR)
                HStack(spacing: 0) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        }) {
                            Text(LocalizedStringKey(tab))
                                .font(.subheadline)
                                .fontWeight(selectedTab == tab ? .bold : .medium)
                                .foregroundColor(selectedTab == tab ? .primary : .secondary)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    ZStack {
                                        if selectedTab == tab {
                                            Capsule()
                                                .fill(Color.secondary.opacity(0.15))
                                                .matchedGeometryEffect(id: "ACTIVE_TAB", in: animation)
                                        }
                                    }
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 15)
                
                // MARK: - İÇERİK KISMI (GRİD)
                if firestoreManager.isLoading {
                    ProgressView()
                        .padding()
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    if selectedTab == "Favorilerim" {
                        // Favoriler Sekmesi
                        if firestoreManager.favoriteMovies.isEmpty {
                            emptyStateView(icon: "heart.slash", title: "Favorin Yok", subtitle: "Sevdiğin filmleri buraya ekleyerek kendi koleksiyonunu oluştur.")
                        } else {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(firestoreManager.favoriteMovies) { movie in
                                    NavigationLink(destination: MovieDetailView(movieId: movie.id, initialTitle: movie.title)) {
                                        MovieCardView(movie: movie)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        // İzleme Listesi Sekmesi
                        if firestoreManager.watchlistMovies.isEmpty {
                            emptyStateView(icon: "bookmark.slash", title: "Listen Boş", subtitle: "Daha sonra izlemek istediğin filmleri kaydedip buradan ulaşabilirsin.")
                        } else {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(firestoreManager.watchlistMovies) { movie in
                                    NavigationLink(destination: MovieDetailView(movieId: movie.id, initialTitle: movie.title)) {
                                        MovieCardView(movie: movie)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer().frame(height: 100)
                }
            }
            .navigationTitle("Kütüphanem")
        }
    }
    
    // MARK: - BOŞ DURUM TASARIMI (EMPTY STATE)
    @ViewBuilder
    func emptyStateView(icon: String, title: LocalizedStringKey, subtitle: LocalizedStringKey) -> some View {
        VStack(spacing: 15) {
            Spacer().frame(height: 120)
            
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.4))
            
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
