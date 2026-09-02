import Foundation

/// Composition root. Constructs and owns the app's dependency graph
/// (API client → data sources → repositories → use cases) and hands out
/// ready-made ViewModels, so Views never construct their own dependencies.
@MainActor
final class AppContainer {
    static let shared = AppContainer()

    let apiClient: APIClient
    let movieRemoteDataSource: MovieRemoteDataSource
    let movieRepository: MovieRepository

    let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let getNowPlayingMoviesUseCase: GetNowPlayingMoviesUseCase
    let getTopRatedMoviesUseCase: GetTopRatedMoviesUseCase
    let getUpcomingMoviesUseCase: GetUpcomingMoviesUseCase
    let searchMoviesUseCase: SearchMoviesUseCase

    private init() {
        let apiClient = URLSessionAPIClient()
        let movieRemoteDataSource = TMDBRemoteDataSource(apiClient: apiClient)
        let movieRepository = MovieRepositoryImpl(remoteDataSource: movieRemoteDataSource)

        self.apiClient = apiClient
        self.movieRemoteDataSource = movieRemoteDataSource
        self.movieRepository = movieRepository

        getTrendingMoviesUseCase = GetTrendingMoviesUseCase(repository: movieRepository)
        getPopularMoviesUseCase = GetPopularMoviesUseCase(repository: movieRepository)
        getNowPlayingMoviesUseCase = GetNowPlayingMoviesUseCase(repository: movieRepository)
        getTopRatedMoviesUseCase = GetTopRatedMoviesUseCase(repository: movieRepository)
        getUpcomingMoviesUseCase = GetUpcomingMoviesUseCase(repository: movieRepository)
        searchMoviesUseCase = SearchMoviesUseCase(repository: movieRepository)
    }
}
