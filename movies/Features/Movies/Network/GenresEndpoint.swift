//
//  GenresEndpoint.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import Foundation

enum GenresEndpoint {
    case movieGenres
}

extension GenresEndpoint: Endpoint {
    var queryItems: [URLQueryItem]? {
        switch self {
        case .movieGenres:
            return [
                URLQueryItem(name: "api_key", value: APIKeyManager.shared.apiKey ?? "")
            ]
        }
    }
    
    var baseURL: URL? {
        return URL(string: "https://api.themoviedb.org/3")
    }

    var path: String {
        switch self {
        case .movieGenres:
            return "/genre/movie/list"
        }
    }

    var method: RequestMethod {
        return .get
    }

    var headers: [String: String]? {
        return nil
    }

}
