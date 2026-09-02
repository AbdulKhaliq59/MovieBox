import SwiftUI

struct RootView: View {
    @Environment(\.appContainer) private var appContainer

    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel(
                getTrendingMoviesUseCase: appContainer.getTrendingMoviesUseCase,
                getPopularMoviesUseCase: appContainer.getPopularMoviesUseCase,
                getNowPlayingMoviesUseCase: appContainer.getNowPlayingMoviesUseCase,
                getTopRatedMoviesUseCase: appContainer.getTopRatedMoviesUseCase,
                getUpcomingMoviesUseCase: appContainer.getUpcomingMoviesUseCase
            ))
            .tabItem { Label("Home", systemImage: "house.fill") }

            SearchView(viewModel: SearchViewModel(
                searchMoviesUseCase: appContainer.searchMoviesUseCase
            ))
            .tabItem { Label("Search", systemImage: "magnifyingglass") }

            FavoritesView(viewModel: FavoritesViewModel(
                getFavoritesUseCase: appContainer.getFavoritesUseCase,
                removeFavoriteUseCase: appContainer.removeFavoriteUseCase
            ))
            .tabItem { Label("Favorites", systemImage: "heart.fill") }
        }
    }
}
