import SwiftUI

struct RootView: View {
    @Environment(\.appContainer) private var appContainer

    var body: some View {
        @Bindable var router = appContainer.router

        TabView(selection: $router.selectedTab) {
            HomeView(viewModel: HomeViewModel(
                getTrendingMoviesUseCase: appContainer.getTrendingMoviesUseCase,
                getPopularMoviesUseCase: appContainer.getPopularMoviesUseCase,
                getNowPlayingMoviesUseCase: appContainer.getNowPlayingMoviesUseCase,
                getTopRatedMoviesUseCase: appContainer.getTopRatedMoviesUseCase,
                getUpcomingMoviesUseCase: appContainer.getUpcomingMoviesUseCase
            ))
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(AppTab.home)

            SearchView(viewModel: SearchViewModel(
                searchMoviesUseCase: appContainer.searchMoviesUseCase
            ))
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(AppTab.search)

            FavoritesView(viewModel: FavoritesViewModel(
                getFavoritesUseCase: appContainer.getFavoritesUseCase,
                removeFavoriteUseCase: appContainer.removeFavoriteUseCase
            ))
            .tabItem { Label("Favorites", systemImage: "heart.fill") }
            .tag(AppTab.favorites)
        }
    }
}
