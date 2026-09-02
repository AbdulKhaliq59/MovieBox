import Foundation

enum AppConfiguration {
    static let tmdbAPIKey = Environment.tmdbAPIKey
    static let tmdbBaseURL = Environment.tmdbBaseURL
    static let tmdbImageBaseURL = Environment.tmdbImageBaseURL
    static let isConfigured = Environment.isConfigured

    static let requestTimeout: TimeInterval = 30
    static let defaultPageSize = 20

    /// TMDB image size path segments, from smallest to largest.
    /// See: https://developer.themoviedb.org/docs/image-basics
    enum ImageSize {
        static let posterSmall = "w185"
        static let posterMedium = "w342"
        static let posterLarge = "w500"
        static let backdrop = "w780"
        static let original = "original"
    }
}
