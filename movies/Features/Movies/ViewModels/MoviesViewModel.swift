//
//  MoviesViewModel.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import Foundation

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1
    @Published var selectedCategory: MovieCategory = .mostPopular
    private(set) var genres: [Int: String] = [:]

    private let networkService = NetworkService.shared

    init() {
        Task {
            await GenreService.shared.fetchGenres()
        }
    }

    enum MovieCategory: String, CaseIterable, Identifiable {
        case mostPopular = "Most Popular"
        case nowPlaying = "Now Playing"

        var id: String { self.rawValue }
    }

    func fetchMovies(page: Int = 1) {
        guard !isLoading else { return }
        guard page <= totalPages else { return }

        isLoading = true
        errorMessage = nil

        let endpoint: MoviesEndpoint
        switch selectedCategory {
        case .mostPopular:
            endpoint = .mostPopularMovies(page: page)
        case .nowPlaying:
            endpoint = .nowPlayingMovies(page: page)
        }

        Task {
            let result = await networkService.sendRequest(
                endpoint: endpoint,
                responseModel: MostPopularResponse.self
            )
            switch result {
            case .success(let response):
                if page == 1 {
                    self.movies = response.results
                } else {
                    self.movies.append(contentsOf: response.results.filter { newMovie in
                        !self.movies.contains { $0.id == newMovie.id }
                    })
                }
                self.currentPage = page
                self.totalPages = response.totalPages
                print("Updated Current Page: \(self.currentPage), Total Pages: \(self.totalPages), Movies Count: \(self.movies.count)")
            case .failure(let error):
                print("Error: \(error)")
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }

    func loadMoreMoviesIfNeeded(currentMovie: Movie) {
        guard let lastMovie = movies.last else { return }
        if currentMovie.id == lastMovie.id && currentPage < totalPages && !isLoading {
            print("Loading more movies...")
            fetchMovies(page: currentPage + 1)
        }
    }

    func switchCategory(to category: MovieCategory) {
        selectedCategory = category
        currentPage = 1
        totalPages = 1
        movies = []
        fetchMovies(page: 1)
    }

}

extension Movie {
    var genresDescription: String {
        let genreNames = genreIds.map { GenreService.shared.genreName(for: $0) }
        return genreNames.joined(separator: ", ")
    }
}


class GenreService {
    static let shared = GenreService()

    private(set) var genres: [Int: String] = [:]

    private init() {}

    func fetchGenres() async {
        let endpoint = GenresEndpoint.movieGenres
        let result = await NetworkService.shared.sendRequest(endpoint: endpoint, responseModel: GenreResponse.self)

        switch result {
        case .success(let response):
            for genre in response.genres {
                genres[genre.id] = genre.name
            }
        case .failure(let error):
            print("Error fetching genres: \(error)")
        }
    }

    func genreName(for id: Int) -> String {
        return genres[id] ?? "Unknown"
    }
}
