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

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1

    private let networkService = NetworkService.shared

    func fetchMostPopularMovies(page: Int = 1) {
        guard !isLoading else { return }
        guard page <= totalPages else { return }

        isLoading = true
        errorMessage = nil

        Task {
            let result = await networkService.sendRequest(
                endpoint: MoviesEndpoint.mostPopularMovies(page: page),
                responseModel: MostPopularResponse.self
            )
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if page == 1 {
                        self.movies = response.results
                    } else {
                        self.movies += response.results
                    }
                    self.currentPage = response.page
                    self.totalPages = response.totalPages
                case .failure(let error):
                    print(error)
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadMoreMoviesIfNeeded(currentMovie: Movie) {
        guard let lastMovie = movies.last else { return }
        if currentMovie.id == lastMovie.id {
            fetchMostPopularMovies(page: currentPage + 1)
        }
    }
}


struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let genreIds: [Int]
    let releaseDate: String
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int

    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case popularity, voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MostPopularResponse: Decodable {
    let page: Int
    let totalPages: Int
    let results: [Movie]

    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results
    }
}

enum MoviesEndpoint {
    case mostPopularMovies(page: Int)
}

extension MoviesEndpoint: Endpoint {
    var baseURL: URL? {
        URL(string: "https://api.themoviedb.org/3/")
    }
    
    var path: String {
        switch self {
        case .mostPopularMovies:
            return "discover/movie"
        }
    }
    
    var method: RequestMethod {
        switch self {
        default:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return [
                "Content-Type": "application/json"
            ]
        }
    }

    var queryItems: [URLQueryItem]? {
          switch self {
          case .mostPopularMovies(let page):
              return [
                  URLQueryItem(name: "page", value: "\(page)"),
                  URLQueryItem(name: "api_key", value: APIKeyManager.shared.apiKey ?? "")
              ]
          }
      }
}

