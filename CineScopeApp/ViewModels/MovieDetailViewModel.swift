//
//  MovieDetailViewModel.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import Foundation
import SwiftUI
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var movieDetails: MovieDetailModel?
    @Published var isLoading: Bool = false
    
    var director: CrewMember? {
        movieDetails?.credits?.crew.first(where: { $0.job == "Director" })
    }
    
    var writers: [CrewMember] {
        movieDetails?.credits?.crew.filter({ $0.job == "Screenplay" || $0.job == "Writer" || $0.job == "Story" }) ?? []
    }
    
    func getDetails(id: Int) {
        isLoading = true
        NetworkManager.shared.fetchMovieDetails(movieID: id) { [weak self] details in
            self?.movieDetails = details
            self?.isLoading = false
        }
    }
}
