import SwiftUI

struct SearchView: View {
    @Environment(\.appContainer) private var appContainer
    @State private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        @Bindable var router = appContainer.router

        NavigationStack(path: $router.searchPath) {
            Group {
                if viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    RecentSearchesView(
                        recentSearches: viewModel.recentSearches,
                        onSelect: { term in Task { await viewModel.selectRecentSearch(term) } },
                        onRemove: viewModel.removeRecentSearch,
                        onClearAll: viewModel.clearRecentSearches
                    )
                } else {
                    SearchResultsView(viewModel: viewModel)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.query, prompt: "Search movies")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailsView(viewModel: MovieDetailsViewModel(
                    movie: movie,
                    getMovieDetailsUseCase: appContainer.getMovieDetailsUseCase,
                    getMovieCreditsUseCase: appContainer.getMovieCreditsUseCase,
                    getSimilarMoviesUseCase: appContainer.getSimilarMoviesUseCase,
                    getMovieVideosUseCase: appContainer.getMovieVideosUseCase,
                    isFavoriteUseCase: appContainer.isFavoriteUseCase,
                    addFavoriteUseCase: appContainer.addFavoriteUseCase,
                    removeFavoriteUseCase: appContainer.removeFavoriteUseCase
                ))
            }
            .navigationDestination(for: MovieDetailsRoute.self) { route in
                MovieDetailsLoaderView(movieID: route.id)
            }
            .task(id: viewModel.query) {
                await viewModel.onQueryChanged()
            }
            .task(id: router.pendingSearchQuery) {
                guard let pending = router.pendingSearchQuery else { return }
                viewModel.query = pending
                router.pendingSearchQuery = nil
            }
        }
    }
}
