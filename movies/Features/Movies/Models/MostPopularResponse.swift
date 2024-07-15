//
//  MostPopularResponse.swift
//  movies
//
//  Created by Carlos Ramos on 14/07/24.
//
import Foundation

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
