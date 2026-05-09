//
//  MovieCardView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let imageBaseURL = "https://image.tmdb.org/t/p/w200"
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ZStack(alignment: .bottomLeading) {
                
                if let posterPath = movie.posterPath, let url = URL(string: imageBaseURL + posterPath) {
                    CachedAsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 140, height: 210)
                    .cornerRadius(12)
                    .clipped()
                } else {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(width: 140, height: 210)
                        .cornerRadius(12)
                }
            
                CircularProgressView(voteAverage: movie.voteAverage)
                    .offset(x: 10, y: 20)
            }
            .padding(.bottom, 20)
            
            Text(movie.title)
                .font(.system(size: 14, weight: .semibold))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 140, alignment: .leading)
        }
    }
}

#Preview {
    let mockMovie = Movie(id: 1, title: "Geleceğe Dönüş (Örnek Film Başlığı)", overview: "Örnek", voteAverage: 8.5, posterPath: nil)
    MovieCardView(movie: mockMovie)
}
