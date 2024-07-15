//
//  Genre.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//

import Foundation

struct Genre: Identifiable, Decodable {
    let id: Int
    let name: String
}

struct GenreResponse: Decodable {
    let genres: [Genre]
}
