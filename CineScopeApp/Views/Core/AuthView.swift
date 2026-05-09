//
//  AuthView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 6.05.2026.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        if viewModel.isAuthenticated {
            MainTabView()
        } else {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 25) {
                        // Logo / İkon kısmı
                        Image(systemName: "film.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .padding(.top, 50)
                        
                        Text("CineScope")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(viewModel.isLoginMode ? "Giriş yap ve sinema dünyasına dal" : "Aramıza katıl ve favorilerini kaydet")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 20)
                        
                        // Hata mesajı varsa göster
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Giriş Formu
                        VStack(spacing: 15) {
                            TextField("E-posta adresi", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(12)
                            
                            SecureField("Şifre", text: $viewModel.password)
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        // Ana Eylem Butonu (Giriş Yap / Kayıt Ol)
                        Button(action: {
                            viewModel.handleAction()
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(viewModel.isLoginMode ? "Giriş Yap" : "Kayıt Ol")
                                        .fontWeight(.bold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Mod Değiştirme (Giriş <-> Kayıt)
                        Button(action: {
                            withAnimation {
                                viewModel.isLoginMode.toggle()
                                viewModel.errorMessage = ""
                            }
                        }) {
                            Text(viewModel.isLoginMode ? "Hesabın yok mu? Yeni Hesap Oluştur" : "Zaten hesabın var mı? Giriş Yap")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
    }
}
