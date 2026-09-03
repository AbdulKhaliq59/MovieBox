import Foundation

@Observable
@MainActor
final class HomeViewModel {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }

    private(set) var loadingState: LoadingState = .idle
    private(set) var trendingMovies: [Movie] = []
    private(set) var popularMovies: [Movie] = []
    private(set) var nowPlayingMovies: [Movie] = []
    private(set) var topRatedMovies: [Movie] = []
    private(set) var upcomingMovies: [Movie] = []

    var featuredMovie: Movie? { trendingMovies.first }
    private var hasContent: Bool { !trendingMovies.isEmpty }

    private let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    private let getPopularMoviesUseCase: GetPopularMoviesUseCase
    private let getNowPlayingMoviesUseCase: GetNowPlayingMoviesUseCase
    private let getTopRatedMoviesUseCase: GetTopRatedMoviesUseCase
    private let getUpcomingMoviesUseCase: GetUpcomingMoviesUseCase

    init(
        getTrendingMoviesUseCase: GetTrendingMoviesUseCase,
        getPopularMoviesUseCase: GetPopularMoviesUseCase,
        getNowPlayingMoviesUseCase: GetNowPlayingMoviesUseCase,
        getTopRatedMoviesUseCase: GetTopRatedMoviesUseCase,
        getUpcomingMoviesUseCase: GetUpcomingMoviesUseCase
    ) {
        self.getTrendingMoviesUseCase = getTrendingMoviesUseCase
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
        self.getNowPlayingMoviesUseCase = getNowPlayingMoviesUseCase
        self.getTopRatedMoviesUseCase = getTopRatedMoviesUseCase
        self.getUpcomingMoviesUseCase = getUpcomingMoviesUseCase
    }

    func loadIfNeeded() async {
        guard !hasContent else { return }
        await load()
    }

    func refresh() async {
        await load()
    }

    private func load() async {
        if !hasContent {
            loadingState = .loading
        }
        do {
            async let trending = getTrendingMoviesUseCase.execute()
            async let popular = getPopularMoviesUseCase.execute(page: 1)
            async let nowPlaying = getNowPlayingMoviesUseCase.execute(page: 1)
            async let topRated = getTopRatedMoviesUseCase.execute(page: 1)
            async let upcoming = getUpcomingMoviesUseCase.execute(page: 1)

            let (trendingResult, popularResult, nowPlayingResult, topRatedResult, upcomingResult) =
                try await (trending, popular, nowPlaying, topRated, upcoming)

            trendingMovies = trendingResult
            popularMovies = popularResult
            nowPlayingMovies = nowPlayingResult
            topRatedMovies = topRatedResult
            upcomingMovies = upcomingResult
            loadingState = .loaded
        } catch {
            let message = (error as? NetworkError)?.userMessage
                ?? NetworkError.unknown(description: error.localizedDescription).userMessage

            // Keep showing existing content if a refresh fails in the background.
            loadingState = hasContent ? .loaded : .error(message)
        }
    }
}
