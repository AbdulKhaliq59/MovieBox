import Foundation

protocol APIClient: Sendable {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class URLSessionAPIClient: APIClient, @unchecked Sendable {
    private let session: URLSession
    private let baseURL: String
    private let apiKey: String
    private let timeout: TimeInterval
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        baseURL: String = AppConfiguration.tmdbBaseURL,
        apiKey: String = AppConfiguration.tmdbAPIKey,
        timeout: TimeInterval = AppConfiguration.requestTimeout
    ) {
        self.session = session
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.timeout = timeout
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let request = try RequestBuilder.buildRequest(
            for: endpoint,
            baseURL: baseURL,
            apiKey: apiKey,
            timeout: timeout
        )

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw NetworkError.noInternet
        } catch {
            throw NetworkError.unknown(description: error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.unknown(description: "Unexpected status code \(httpResponse.statusCode)")
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
