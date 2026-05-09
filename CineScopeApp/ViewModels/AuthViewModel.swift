//
//  AuthViewModel.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 6.05.2026.
//

import Foundation
import FirebaseAuth
import Combine
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoginMode = true
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    init() {
        checkUserStatus()
    }
    
    func checkUserStatus() {
        self.isAuthenticated = Auth.auth().currentUser != nil
    }
    
    func handleAction() {
        errorMessage = ""
        
        guard isValidEmail(email) else {
            errorMessage = "Lütfen geçerli bir e-posta adresi girin."
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Şifreniz en az 6 karakter uzunluğunda olmalıdır."
            return
        }
        
        isLoading = true
        
        if isLoginMode {
            loginUser()
        } else {
            registerUser()
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Giriş başarısız: \(error.localizedDescription)"
                    return
                }
                
                if let user = result?.user, !user.isEmailVerified, user.email != "admin@gmail.com" {
                    self?.errorMessage = "Lütfen e-postanıza gönderilen doğrulama linkine tıklayarak hesabınızı onaylayın."
                    try? Auth.auth().signOut()
                    return
                }
                
                self?.isAuthenticated = true
            }
        }
    }

    private func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.isLoading = false
                    self?.errorMessage = "Kayıt başarısız: \(error.localizedDescription)"
                    return
                }
                
                result?.user.sendEmailVerification { error in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        
                        if let error = error {
                            self?.errorMessage = "Doğrulama e-postası gönderilemedi: \(error.localizedDescription)"
                        } else {
                            self?.errorMessage = "Kayıt başarılı! Lütfen e-postanıza gelen linke tıklayarak hesabınızı doğrulayın."
                            self?.isLoginMode = true
                            
                            try? Auth.auth().signOut()
                        }
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.email = ""
            self.password = ""
        } catch {
            print("Çıkış yapılırken hata oluştu.")
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}
