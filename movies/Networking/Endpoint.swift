//
//  Endpoint.swift
//  movies
//
//  Created by Carlos Ramos on 12/07/24.
//

import Foundation

protocol Endpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
}
