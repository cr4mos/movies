//
//  APIKeyManager.swift
//  movies
//
//  Created by Carlos Ramos on 15/07/24.
//

import Foundation

class APIKeyManager {
    static let shared = APIKeyManager()

    private let keychainService = "com.mymovieapp.api"
    private let apiKeyAccount = "apiKey"

    var apiKey: String? {
        get {
            // Try to read from Keychain first
            if let data = KeychainHelper.shared.read(service: keychainService, account: apiKeyAccount),
               let key = String(data: data, encoding: .utf8) {
                return key
            }
            // If not available in Keychain, get from Info.plist
            if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
                self.apiKey = key // Save to Keychain for future use
                return key
            }
            return nil
        }
        set {
            guard let value = newValue else {
                KeychainHelper.shared.delete(service: keychainService, account: apiKeyAccount)
                return
            }
            let data = Data(value.utf8)
            KeychainHelper.shared.save(data, service: keychainService, account: apiKeyAccount)
        }
    }
}
