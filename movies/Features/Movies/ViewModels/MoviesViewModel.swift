//
//  MoviesViewModel.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import SwiftUI

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isEmptyState: Bool = false

    private let networkService = NetworkService.shared
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var currentCategory: Category = .mostPopular

    enum Category {
        case mostPopular
        case nowPlaying
    }

    func switchCategory(to category: Category) {
        currentCategory = category
        reset()
    }

    func fetchMovies(page: Int = 1) {
        isLoading = true
        errorMessage = nil
        isEmptyState = false

        Task {
            let endpoint: MoviesEndpoint = currentCategory == .mostPopular ? .mostPopularMovies(page: page) : .nowPlayingMovies(page: page)
            let result = await networkService.sendRequest(endpoint: endpoint, responseModel: MostPopularResponse.self)

            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.results.isEmpty {
                        self.isEmptyState = true
                    } else {
                        self.currentPage = response.page
                        self.totalPages = response.totalPages
                        self.movies.append(contentsOf: response.results)
                    }
                case .failure(let error):
                    self.errorMessage = error.errorDescription
                }
            }
        }
    }

    func loadMoreMoviesIfNeeded(currentMovie: Movie) {
        guard let lastMovie = movies.last else { return }
        if currentMovie.id == lastMovie.id && currentPage < totalPages {
            fetchMovies(page: currentPage + 1)
        }
    }

    private func reset() {
        movies = []
        currentPage = 1
        totalPages = 1
        fetchMovies()
    }
}
