//
//  SearchViewModel.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchResults: [Movie] = []
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchQuery
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] query in
                if query.trimmingCharacters(in: .whitespaces).isEmpty {
                    self?.searchResults = []
                    self?.isLoading = false
                } else {
                    self?.isLoading = true
                }
            }
            .store(in: &cancellables)
        
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates() // Aynı kelimeyse boşuna interneti yorma
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    func performSearch(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        NetworkManager.shared.searchMovies(query: query) { [weak self] movies in
            self?.searchResults = movies ?? []
            self?.isLoading = false
        }
    }
}
