//
//  ProfileView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 7.05.2026.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @State private var userEmail: String = Auth.auth().currentUser?.email ?? "Kullanıcı"
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    
                    // MARK: - 1. PROFİL BİLGİSİ
                    VStack(spacing: 15) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .background(Circle().fill(Color.blue.opacity(0.1)))
                        
                        Text(userEmail)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 30)
                    
                    // MARK: - 2. İSTATİSTİK KARTI
                    HStack(spacing: 40) {
                        VStack(spacing: 5) {
                            Text("\(firestoreManager.favoriteMovies.count)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Favoriler")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider().frame(height: 40)
                        
                        VStack(spacing: 5) {
                            Text("\(firestoreManager.watchlistMovies.count)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Listem")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 30)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.secondary.opacity(0.15)))
                    
                    // MARK: - 3. TIKLANABİLİR LİSTE SEÇENEKLERİ
                    VStack(spacing: 0) {
                        // 1. Ayarlar Butonu
                        NavigationLink(destination: SettingsView()) {
                            ProfileMenuRowView(icon: "gearshape.fill", title: "Hesap Ayarları", color: .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider().padding(.leading, 50)
                        
                        // 2. Bildirimler Butonu
                        NavigationLink(destination: Text("Bildirimler Sayfası Çok Yakında...").font(.title2)) {
                            ProfileMenuRowView(icon: "bell.fill", title: "Bildirimler", color: .orange)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider().padding(.leading, 50)
                        
                        // 3. Puanla Butonu
                        Button(action: {
                            print("Uygulamayı Puanla Tıklandı")
                        }) {
                            ProfileMenuRowView(icon: "star.fill", title: "Uygulamayı Puanla", color: .yellow)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.secondary.opacity(0.15)))
                    .padding(.horizontal)
                    
                    // MARK: - 4. AKILLI ÇIKIŞ YAP BUTONU
                    // ProfileView.swift içindeki Çıkış Yap butonu aksiyonu:
                    Button(action: {
                        do {
                            FirestoreManager.shared.clearData()
                            
                            try Auth.auth().signOut()
                            
                        } catch {
                            print("Çıkış yapılamadı: \(error.localizedDescription)")
                        }
                    }){
                        Text("Çıkış Yap")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.red.opacity(0.15)))
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer().frame(height: 100)
                }
            }
            .navigationTitle("Profilim")
        }
    }
}

struct ProfileMenuRowView: View {
    let icon: String
    let title: LocalizedStringKey
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.footnote)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .contentShape(Rectangle())
    }
}
