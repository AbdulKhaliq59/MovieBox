import SwiftUI

struct FavoritesView: View {
    @Environment(\.appContainer) private var appContainer
    @State private var viewModel: FavoritesViewModel

    init(viewModel: FavoritesViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .loading:
                    LoadingView()
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.load() }
                    }
                case .loaded:
                    if viewModel.favorites.isEmpty {
                        EmptyStateView(
                            systemImage: "heart",
                            title: "No favorites yet",
                            message: "Save movies you want to watch later."
                        )
                    } else {
                        favoritesGrid
                    }
                }
            }
            .navigationTitle("Favorites")
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
            .onAppear { Task { await viewModel.load() } }
        }
    }

    private var favoritesGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 16)], spacing: 20) {
                ForEach(viewModel.favorites) { movie in
                    NavigationLink(value: movie) {
                        MovieCard(movie: movie, width: 140)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            Task { await viewModel.remove(movie) }
                        } label: {
                            Label("Remove from Favorites", systemImage: "heart.slash")
                        }
                    }
                }
            }
            .padding()
        }
    }
}
