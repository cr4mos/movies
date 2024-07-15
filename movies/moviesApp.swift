//
//  moviesApp.swift
//  movies
//
//  Created by Carlos Ramos on 12/07/24.
//

import SwiftUI

@main
struct moviesApp: App {
    init() {
        if APIKeyManager.shared.apiKey == nil {
            APIKeyManager.shared.apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
            print("API Key at init:", APIKeyManager.shared.apiKey ?? "nil") // Debug print
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
