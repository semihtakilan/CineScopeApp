//
//  PersonDetailModel.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import Foundation

struct PersonDetailModel: Codable {
    let id: Int
    let name: String
    let biography: String
    let profilePath: String?
    let birthday: String?
    let deathday: String?
    let placeOfBirth: String?
    let knownForDepartment: String?
    var movieCredits: PersonMovieCredits?
    
    enum CodingKeys: String, CodingKey {
        case id, name, biography, birthday
        case deathday
        case profilePath = "profile_path"
        case placeOfBirth = "place_of_birth"
        case knownForDepartment = "known_for_department"
        case movieCredits = "movie_credits"
    }
    
    var calculatedAge: String {
        guard let birthdayString = birthday else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let birthDate = formatter.date(from: birthdayString) else { return "" }
        
        if let deathdayString = deathday, let deathDate = formatter.date(from: deathdayString) {
            let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: deathDate)
            if let years = ageComponents.year {
                return "\(years) yaşında vefat etti"
            }
        } else {
            let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: Date())
            if let years = ageComponents.year {
                return "\(years) yaşında"
            }
        }
        
        return ""
    }
}

struct PersonMovieCredits: Codable {
    var cast: [Movie]
}
