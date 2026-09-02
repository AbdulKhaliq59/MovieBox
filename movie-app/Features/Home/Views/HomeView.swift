import SwiftUI

struct HomeView: View {
    @Environment(\.appContainer) private var appContainer
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .idle, .loading:
                    HomeSkeletonView()
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.refresh() }
                    }
                case .loaded:
                    movieList
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: viewModel.loadingState)
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ThemePickerMenu(themeManager: appContainer.themeManager)
                }
            }
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
            .task { await viewModel.loadIfNeeded() }
            .refreshable { await viewModel.refresh() }
        }
    }

    private var movieList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                if let featured = viewModel.featuredMovie {
                    FeaturedMovieView(movie: featured)
                }
                MovieSectionView(title: "Trending", movies: viewModel.trendingMovies)
                MovieSectionView(title: "Popular", movies: viewModel.popularMovies)
                MovieSectionView(title: "Now Playing", movies: viewModel.nowPlayingMovies)
                MovieSectionView(title: "Top Rated", movies: viewModel.topRatedMovies)
                MovieSectionView(title: "Upcoming", movies: viewModel.upcomingMovies)
            }
            .padding(.vertical)
        }
    }
}
