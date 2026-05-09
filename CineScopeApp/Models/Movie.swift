//
//  Movie.swift
//  CineScope
//
//  Created by Semih TAKILAN on 23.12.2025.
//

import SwiftUI
import Foundation

struct MovieResponse: Codable, Sendable {
    let results: [Movie]
}

struct Movie: Codable, Sendable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let voteAverage: Double
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}

struct MovieCategory: Identifiable {
    let id = UUID()
    let title: LocalizedStringKey
    let movies: [Movie]
}
