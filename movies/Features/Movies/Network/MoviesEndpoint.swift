//
//  MoviesEndpoint.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import Foundation

enum MoviesEndpoint {
    case mostPopularMovies(page: Int)
    case nowPlayingMovies(page: Int)
}

extension MoviesEndpoint: Endpoint {
    var baseURL: URL? {
        return URL(string: "https://api.themoviedb.org/3")
    }

    var path: String {
        switch self {
        case .mostPopularMovies:
            return "/movie/popular"
        case .nowPlayingMovies:
            return "/movie/now_playing"
        }
    }

    var method: RequestMethod {
        return .get
    }

    var headers: [String: String]? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .mostPopularMovies(let page), .nowPlayingMovies(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "api_key", value: APIKeyManager.shared.apiKey ?? "")
            ]
        }
    }
}

