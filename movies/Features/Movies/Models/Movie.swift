//
//  Movie.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import Foundation

struct Movie: Identifiable, Decodable {
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
    let originalLanguage: String

    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
    }
}

extension Movie {
    var genresDescription: String {
        let genreNames = genreIds.map { GenreService.shared.genreName(for: $0) }
        return genreNames.joined(separator: ", ")
    }
}
