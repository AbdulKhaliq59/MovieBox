import Foundation


enum AppEnvironment {
    static var tmdbAPIKey: String { Secrets.tmdbAPIKey }
    static var tmdbBaseURL: String { Secrets.tmdbBaseURL }
    static var tmdbImageBaseURL: String { Secrets.tmdbImageBaseURL }

    static var isConfigured: Bool {
        !tmdbAPIKey.isEmpty && tmdbAPIKey != "YOUR_TMDB_API_KEY"
    }
}
