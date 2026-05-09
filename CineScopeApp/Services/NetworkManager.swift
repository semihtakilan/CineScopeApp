//
//  NetworkManager.swift
//  CineScope
//
//  Created by Semih TAKILAN on 23.12.2025.

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let apiKey = APIKeys.tmdbKey
    private let baseURL = "https://api.themoviedb.org/3/movie/"
    
    private init() {}
    
    enum Endpoint: String {
        case popular = "popular"
        case upcoming = "upcoming"
        case topRated = "top_rated"
        case nowPlaying = "now_playing"
    }

    private var apiLanguage: String {
        let savedLanguage = UserDefaults.standard.string(forKey: "app_language") ??
                            (Locale.current.language.languageCode?.identifier ?? "en")
        
        return savedLanguage == "tr" ? "tr-TR" : "en-US"
    }
    
    func fetchMovies(from endpoint: Endpoint, completion: @escaping ([Movie]?) -> Void) {
        
        let urlString = "\(baseURL)\(endpoint.rawValue)?api_key=\(apiKey)&language=\(apiLanguage)&page=1"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MovieResponse.self, from: data)
                    completion(response.results)
                } catch {
                    print("JSON Hatası: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func fetchMovieDetails(movieID: Int, completion: @escaping (MovieDetailModel?) -> Void) {
        let urlString = "\(baseURL)\(movieID)?api_key=\(apiKey)&language=\(apiLanguage)&append_to_response=credits,similar"
            
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
                
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let detailResponse = try decoder.decode(MovieDetailModel.self, from: data)
                    completion(detailResponse)
                } catch {
                    print("Detay JSON Çözme Hatası: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    // Arama Fonksiyonu
    func searchMovies(query: String, completion: @escaping ([Movie]?) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(nil)
            return
        }
            
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=\(apiLanguage)&query=\(encodedQuery)&page=1"
            
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
                
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(MovieResponse.self, from: data)
                    completion(searchResponse.results)
                } catch {
                    print("Arama Hatası: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    // Oyuncu Detayı ve Filmlerini Çekme
    func fetchPersonDetails(personID: Int, completion: @escaping (PersonDetailModel?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/person/\(personID)?api_key=\(apiKey)&language=\(apiLanguage)&append_to_response=movie_credits"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let personResponse = try decoder.decode(PersonDetailModel.self, from: data)
                    completion(personResponse)
                } catch {
                    print("Oyuncu Detay Hatası: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
