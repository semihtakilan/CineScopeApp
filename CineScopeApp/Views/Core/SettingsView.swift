//
//  SettingsView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 7.05.2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("app_language") private var appLanguage = "tr"
    
    @AppStorage("app_theme") private var appTheme: Int = 0
    
    var body: some View {
        List {
            Section(header: Text("Uygulama Ayarları")) {
                Picker("Uygulama Dili", selection: $appLanguage) {
                    Text("Türkçe").tag("tr")
                    Text("English").tag("en")
                }
                .pickerStyle(.navigationLink)
                .onChange(of: appLanguage) {
                    FirestoreManager.shared.fetchFavorites()
                    FirestoreManager.shared.fetchWatchlist()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tema")
                    Picker("Tema", selection: $appTheme) {
                        Text("Sistem").tag(0)
                        Text("Aydınlık").tag(1)
                        Text("Karanlık").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 5)
            }
            
            Section {
                Text("CineScope v1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Hesap Ayarları")
    }
}
