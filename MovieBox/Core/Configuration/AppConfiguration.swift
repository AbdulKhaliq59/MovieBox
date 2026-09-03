import Foundation

enum AppConfiguration {
    static let tmdbAPIKey = AppEnvironment.tmdbAPIKey
    static let tmdbBaseURL = AppEnvironment.tmdbBaseURL
    static let tmdbImageBaseURL = AppEnvironment.tmdbImageBaseURL
    static let isConfigured = AppEnvironment.isConfigured

    static let requestTimeout: TimeInterval = 30
    static let defaultPageSize = 20

    enum ImageSize {
        static let posterSmall = "w185"
        static let posterMedium = "w342"
        static let posterLarge = "w500"
        static let backdrop = "w780"
        static let original = "original"
    }
}
