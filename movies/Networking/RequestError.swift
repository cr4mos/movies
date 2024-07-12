//
//  RequestError.swift
//  movies
//
//  Created by Carlos Ramos on 12/07/24.
//

import Foundation

enum RequestError: LocalizedError {
    case encode
    case decode
    case invalidURL(String)
    case noResponse
    case unauthorized
    case unexpectedStatusCode(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .encode:
            return "Failed to encode the request body."
        case .decode:
            return "Failed to decode the response."
        case .unauthorized:
            return "Unauthorized request. Session may have expired."
        case .invalidURL(let message):
            return "Invalid URL: \(message)"
        case .unexpectedStatusCode(let message):
            return "Unexpected status code: \(message)"
        case .unknown(let message):
            return "Unknown error occurred: \(message)"
        case .noResponse:
            return "No response from the server."
        }
    }
}
