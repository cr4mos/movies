//
//  HTTPClient.swift
//  movies
//
//  Created by Carlos Ramos on 12/07/24.
//

import Foundation

// MARK: - HTTPClient Extension
protocol HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError>
}

// MARK: - HTTPClient Extension
extension HTTPClient {
    // Build URLRequest from Endpoint
    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let baseURL = endpoint.baseURL else {
            throw RequestError.invalidURL("Base URL is nil")
        }

        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path += endpoint.path

        guard let url = urlComponents?.url else {
            throw RequestError.invalidURL("Invalid URL components")
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        return request
    }

    // Send Request without Body
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        do {
            let request = try buildRequest(from: endpoint)
            return await performRequest(request, responseModel: responseModel)
        } catch let error as RequestError {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    // Perform the actual network request
    private func performRequest<T: Decodable>(
        _ request: URLRequest,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        do {
            guard let apiKey = APIKeyManager.shared.apiKey else {
                return .failure(.invalidURL("API key is missing"))
            }

            var request = request
            var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = (urlComponents.queryItems ?? []) + [URLQueryItem(name: "api_key", value: apiKey)]
            request.url = urlComponents.url

            let (data, response) = try await URLSession.shared.data(for: request)
            log(request: request, data: data, response: response)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }

            switch httpResponse.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode("Received HTTP status code: \(httpResponse.statusCode)"))
            }
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    // Log the request and response for debugging purposes
    private func log(request: URLRequest, data: Data?, response: URLResponse?) {
        #if DEBUG
        print("Request: \(request)")
        if let data = data {
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "N/A")")
        }
        if let response = response {
            print("Response: \(response)")
        }
        #endif
    }
}
