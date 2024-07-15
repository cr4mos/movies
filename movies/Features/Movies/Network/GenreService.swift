//
//  GenreService.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import Foundation

class GenreService {
    static let shared = GenreService()

    @Published private(set) var genres: [Int: String] = [:]

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
