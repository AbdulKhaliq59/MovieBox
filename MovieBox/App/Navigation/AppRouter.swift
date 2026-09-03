import Foundation
import SwiftUI

@Observable
@MainActor
final class AppRouter {
    var selectedTab: AppTab = .home
    var homePath = NavigationPath()
    var searchPath = NavigationPath()
    var favoritesPath = NavigationPath()

    /// Set by a `.search` deep link; `SearchView` consumes and clears it.
    var pendingSearchQuery: String?

    func handle(url: URL) {
        guard let deepLink = DeepLink(url: url) else { return }
        handle(deepLink)
    }

    func handle(_ deepLink: DeepLink) {
        switch deepLink {
        case .home:
            selectedTab = .home
            homePath = NavigationPath()

        case .favorites:
            selectedTab = .favorites
            favoritesPath = NavigationPath()

        case .search(let query):
            selectedTab = .search
            searchPath = NavigationPath()
            pendingSearchQuery = query

        case .movieDetails(let id):
            let route = MovieDetailsRoute(id: id)
            switch selectedTab {
            case .home: homePath.append(route)
            case .search: searchPath.append(route)
            case .favorites: favoritesPath.append(route)
            }
        }
    }
}
