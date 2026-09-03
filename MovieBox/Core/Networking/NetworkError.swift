import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case decodingError
    case noInternet
    case unknown(description: String)
}

extension NetworkError {
    /// User-facing message. Views should display this instead of the raw error.
    var userMessage: String {
        switch self {
        case .invalidURL, .invalidResponse, .decodingError:
            return "Something went wrong. Please try again."
        case .unauthorized, .forbidden:
            return "Unable to access this content right now."
        case .notFound:
            return "We couldn't find what you're looking for."
        case .serverError:
            return "The server is having trouble. Please try again shortly."
        case .noInternet:
            return "No internet connection. Please check your connection and try again."
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
}
