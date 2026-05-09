//
//  CineScopeAppApp.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}

@main
struct CineScopeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("app_language") private var appLanguage = "tr"
    
    @AppStorage("app_theme") private var appTheme: Int = 0
    
    @State private var currentUserID: String? = nil
    
    var selectedColorScheme: ColorScheme? {
        switch appTheme {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            AuthView()
                .environment(\.locale, .init(identifier: appLanguage))
                .preferredColorScheme(selectedColorScheme)
                .id("\(appLanguage)\(currentUserID ?? "guest")")
                .onAppear {
                    _ = Auth.auth().addStateDidChangeListener { _, user in
                        self.currentUserID = user?.uid
                    }
                }
        }
    }
}
