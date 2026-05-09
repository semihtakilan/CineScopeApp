//
//  MainTabView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // 1. Sekme: Ana Sayfa
            ContentView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Ana Sayfa")
                }
            
            // 2. Sekme: Arama
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Ara")
                }
            
            // 3. Sekme: Kütüphane
            LibraryView()
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Kütüphane")
                }
            
            // 4. SEKME: Profil
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profil")
                }
        }
        .accentColor(.white)
    }
}
