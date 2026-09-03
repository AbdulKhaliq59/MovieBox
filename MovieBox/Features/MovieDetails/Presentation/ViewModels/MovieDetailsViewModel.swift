import Foundation

@Observable
@MainActor
final class MovieDetailsViewModel {
    enum LoadingState: Equatable {
        case loading
        case loaded
        case error(String)
    }

    let movie: Movie
    private(set) var loadingState: LoadingState = .loading
    private(set) var details: MovieDetails?
    private(set) var cast: [CastMember] = []
    private(set) var similarMovies: [Movie] = []
    private(set) var trailer: Video?
    private(set) var isFavorite = false

    private let getMovieDetailsUseCase: GetMovieDetailsUseCase
    private let getMovieCreditsUseCase: GetMovieCreditsUseCase
    private let getSimilarMoviesUseCase: GetSimilarMoviesUseCase
    private let getMovieVideosUseCase: GetMovieVideosUseCase
    private let isFavoriteUseCase: IsFavoriteUseCase
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase

    init(
        movie: Movie,
        getMovieDetailsUseCase: GetMovieDetailsUseCase,
        getMovieCreditsUseCase: GetMovieCreditsUseCase,
        getSimilarMoviesUseCase: GetSimilarMoviesUseCase,
        getMovieVideosUseCase: GetMovieVideosUseCase,
        isFavoriteUseCase: IsFavoriteUseCase,
        addFavoriteUseCase: AddFavoriteUseCase,
        removeFavoriteUseCase: RemoveFavoriteUseCase
    ) {
        self.movie = movie
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
        self.getMovieCreditsUseCase = getMovieCreditsUseCase
        self.getSimilarMoviesUseCase = getSimilarMoviesUseCase
        self.getMovieVideosUseCase = getMovieVideosUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
    }

    func loadIfNeeded() async {
        guard details == nil else { return }
        loadingState = .loading
        do {
            async let detailsResult = getMovieDetailsUseCase.execute(id: movie.id)
            async let castResult = getMovieCreditsUseCase.execute(id: movie.id)
            async let similarResult = getSimilarMoviesUseCase.execute(id: movie.id, page: 1)
            async let videosResult = getMovieVideosUseCase.execute(id: movie.id)
            async let favoriteResult = isFavoriteUseCase.execute(id: movie.id)

            let (detailsValue, castValue, similarValue, videosValue, favoriteValue) =
                try await (detailsResult, castResult, similarResult, videosResult, favoriteResult)

            details = detailsValue
            cast = castValue
            similarMovies = similarValue
            trailer = videosValue.first { $0.isYouTubeTrailer }
            isFavorite = favoriteValue
            loadingState = .loaded
        } catch {
            let message = (error as? NetworkError)?.userMessage
                ?? NetworkError.unknown(description: error.localizedDescription).userMessage
            loadingState = .error(message)
        }
    }

    func toggleFavorite() async {
        do {
            if isFavorite {
                try await removeFavoriteUseCase.execute(id: movie.id)
                isFavorite = false
            } else {
                try await addFavoriteUseCase.execute(movie)
                isFavorite = true
            }
        } catch {
            // Best-effort; favoriting is non-critical, leave state unchanged on failure.
        }
    }
}
