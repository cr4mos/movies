//
//  HTTPClient.swift
//  movies
//
//  Created by Carlos Ramos on 12/07/24.
//

import Foundation

// MARK: - HTTP Client Protocol
protocol HTTPClient {
    func sendRequest<T: Decodable, U: Encodable>(
        endpoint: Endpoint,
        requestBody: U?,
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

    // Send Request with Optional Body
    func sendRequest<T: Decodable, U: Encodable>(
        endpoint: Endpoint,
        requestBody: U? = nil,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        do {
            var request = try buildRequest(from: endpoint)
            if let requestBody = requestBody {
                let jsonData = try JSONEncoder().encode(requestBody)
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
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
            let (data, response) = try await URLSession.shared.data(for: request)
            log(request: request, data: data, response: response)
            return handleResponse(data, response, responseModel)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    // Handle the response and decode
    private func handleResponse<T: Decodable>(
        _ data: Data?,
        _ response: URLResponse?,
        _ responseModel: T.Type
    ) -> Result<T, RequestError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noResponse)
        }
        switch httpResponse.statusCode {
        case 200...299:
            guard let data = data, let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                return .failure(.decode)
            }
            return .success(decodedResponse)
        case 401:
            return .failure(.unauthorized)
        default:
            return .failure(.unexpectedStatusCode("Received HTTP status code: \(httpResponse.statusCode)"))
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
