//
//  MovieDetail.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import Foundation

// 1. Detaylı Film Modeli
struct MovieDetailModel: Codable {
    let id: Int
    let title: String
    let overview: String
    let voteAverage: Double
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let genres: [Genre]?
    let credits: Credits?
    let similar: MovieResponse?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, credits, similar
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
    }
    
    var year: String {
        guard let date = releaseDate, date.count >= 4 else { return "" }
        return String(date.prefix(4))
    }
    
    var formattedRuntime: String {
        guard let runtime = runtime else { return "" }
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 ? "\(hours)s \(minutes)dk" : "\(minutes)dk"
    }
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

// 2. Ekip ve Kadro Modeli
struct Credits: Codable {
    let cast: [CastMember]
    let crew: [CrewMember]
}

struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}

struct CrewMember: Codable, Identifiable {
    let creditId: String
    let name: String
    let job: String
    
    var id: String { creditId }
    
    enum CodingKeys: String, CodingKey {
        case name, job
        case creditId = "credit_id"
    }
}
