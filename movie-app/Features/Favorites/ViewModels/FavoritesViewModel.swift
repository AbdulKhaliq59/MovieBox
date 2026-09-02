import Foundation

@Observable
@MainActor
final class FavoritesViewModel {
    enum LoadingState: Equatable {
        case loading
        case loaded
        case error(String)
    }

    private(set) var favorites: [Movie] = []
    private(set) var loadingState: LoadingState = .loading

    private let getFavoritesUseCase: GetFavoritesUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase

    init(getFavoritesUseCase: GetFavoritesUseCase, removeFavoriteUseCase: RemoveFavoriteUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
    }

    func load() async {
        loadingState = .loading
        do {
            favorites = try await getFavoritesUseCase.execute()
            loadingState = .loaded
        } catch {
            loadingState = .error("Something went wrong loading your favorites.")
        }
    }

    func remove(_ movie: Movie) async {
        do {
            try await removeFavoriteUseCase.execute(id: movie.id)
            favorites.removeAll { $0.id == movie.id }
        } catch {
            // Best-effort; keep the list as-is on failure.
        }
    }
}
