import SwiftUI

struct MovieDetailsLoaderView: View {
    let movieID: Int

    @Environment(\.appContainer) private var appContainer
    @State private var resolvedMovie: Movie?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let resolvedMovie {
                MovieDetailsView(viewModel: MovieDetailsViewModel(
                    movie: resolvedMovie,
                    getMovieDetailsUseCase: appContainer.getMovieDetailsUseCase,
                    getMovieCreditsUseCase: appContainer.getMovieCreditsUseCase,
                    getSimilarMoviesUseCase: appContainer.getSimilarMoviesUseCase,
                    getMovieVideosUseCase: appContainer.getMovieVideosUseCase,
                    isFavoriteUseCase: appContainer.isFavoriteUseCase,
                    addFavoriteUseCase: appContainer.addFavoriteUseCase,
                    removeFavoriteUseCase: appContainer.removeFavoriteUseCase
                ))
            } else if let errorMessage {
                ErrorView(message: errorMessage) {
                    Task { await resolve() }
                }
            } else {
                MovieDetailsSkeletonView()
            }
        }
        .task {
            await resolve()
        }
    }

    private func resolve() async {
        errorMessage = nil
        do {
            let details = try await appContainer.getMovieDetailsUseCase.execute(id: movieID)
            resolvedMovie = Movie(
                id: details.id,
                title: details.title,
                overview: details.overview,
                posterPath: details.posterPath,
                backdropPath: details.backdropPath,
                rating: details.rating,
                voteCount: details.voteCount,
                releaseDate: details.releaseDate
            )
        } catch {
            errorMessage = (error as? NetworkError)?.userMessage
                ?? NetworkError.unknown(description: error.localizedDescription).userMessage
        }
    }
}
