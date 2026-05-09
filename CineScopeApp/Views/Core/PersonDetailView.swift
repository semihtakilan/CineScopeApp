//
//  PersonDetailView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import SwiftUI

struct PersonDetailView: View {
    let personId: Int
    
    @StateObject private var viewModel = PersonDetailViewModel()
    @State private var isBioExpanded: Bool = false
    
    let profileBaseURL = "https://image.tmdb.org/t/p/w500"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.isLoading {
                ProgressView("Oyuncu Yükleniyor...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 200)
            } else if let details = viewModel.personDetails {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - 1. PROFİL FOTOĞRAFI VE KİMLİK
                    HStack(alignment: .top, spacing: 20) {
                        // Sol Taraf: Fotoğraf
                        if let profilePath = details.profilePath, let url = URL(string: profileBaseURL + profilePath) {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } else {
                                    Rectangle().fill(Color.gray.opacity(0.3))
                                }
                            }
                            .frame(width: 140, height: 210)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 140, height: 210)
                                .overlay(Image(systemName: "person.fill").font(.largeTitle).foregroundColor(.gray))
                        }
                        
                        // Sağ Taraf: İsim ve Kişisel Bilgiler
                        VStack(alignment: .leading, spacing: 10) {
                            Text(details.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                if let department = details.knownForDepartment {
                                    Text(department == "Acting" ? "Oyuncu" : department)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                }
                                
                                if !details.calculatedAge.isEmpty {
                                    Text(details.calculatedAge)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                if let birthplace = details.placeOfBirth {
                                    HStack(alignment: .top) {
                                        Image(systemName: "mappin.and.ellipse")
                                            .foregroundColor(.secondary)
                                        Text(birthplace)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.top, 4)
                                }
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // MARK: - 2. BİYOGRAFİ (Okuması Keyifli Tasarım)
                    if !details.biography.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Biyografi")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Text(details.biography)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(5)
                                .lineLimit(isBioExpanded ? nil : 4)
                                .animation(.easeInOut, value: isBioExpanded)
                                .onTapGesture {
                                    withAnimation {
                                        isBioExpanded.toggle()
                                    }
                                }
                            
                            // Devamını oku butonu
                            Button(action: {
                                withAnimation {
                                    isBioExpanded.toggle()
                                }
                            }) {
                                Text(isBioExpanded ? "Daha az göster" : "Devamını oku...")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // MARK: - 3. ROL ALDIĞI PROJELER
                    if let movies = details.movieCredits?.cast, !movies.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Divider().padding(.horizontal, 20).padding(.vertical, 5)
                            
                            Text("Rol Aldığı Projeler")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(movies) { movie in
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
                    }
                    
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getPersonDetails(id: personId)
        }
    }
}
