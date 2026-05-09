//
//  PersonDetailViewModel.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import Foundation
import SwiftUI
import Combine

class PersonDetailViewModel: ObservableObject {
    @Published var personDetails: PersonDetailModel?
    @Published var isLoading: Bool = false
    
    func getPersonDetails(id: Int) {
        isLoading = true
        NetworkManager.shared.fetchPersonDetails(personID: id) { [weak self] details in
            self?.personDetails = details
            if let cast = self?.personDetails?.movieCredits?.cast {
                self?.personDetails?.movieCredits?.cast = cast.sorted(by: { $0.voteAverage > $1.voteAverage })
            }
            self?.isLoading = false
        }
    }
}
