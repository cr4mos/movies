//
//  Movie.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import Foundation

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
