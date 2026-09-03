import Foundation

/// Parses URLs of the form `moviebox://<host>[/<path>][?<query>]`.
///
/// Supported links:
///   moviebox://home
///   moviebox://search?q=<term>
///   moviebox://favorites
///   moviebox://movie/<id>
enum DeepLink: Equatable {
    case home
    case search(query: String?)
    case favorites
    case movieDetails(id: Int)

    init?(url: URL) {
        guard url.scheme == "moviebox" else { return nil }

        guard let host = url.host, !host.isEmpty else {
            self = .home
            return
        }

        switch host {
        case "home":
            self = .home
        case "favorites":
            self = .favorites
        case "search":
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let query = components?.queryItems?.first(where: { $0.name == "q" })?.value
            self = .search(query: query)
        case "movie":
            guard
                let idString = url.pathComponents.first(where: { $0 != "/" }),
                let id = Int(idString)
            else { return nil }
            self = .movieDetails(id: id)
        default:
            return nil
        }
    }
}
