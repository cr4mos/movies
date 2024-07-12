//
//  NetworkService.swift
//  movies
//
//  Created by Carlos Ramos on 12/07/24.
//

import Foundation

class NetworkService: HTTPClient {
    static let shared = NetworkService()
    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        session = URLSession(configuration: configuration)
    }
}
