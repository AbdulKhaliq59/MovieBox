import Foundation
import SwiftData

@MainActor
final class AppContainer {
    static let shared = AppContainer()

    let apiClient: APIClient
    let movieRemoteDataSource: MovieRemoteDataSource
    let movieRepository: MovieRepository
    let modelContainer: ModelContainer
    let favoritesLocalDataSource: FavoritesLocalDataSource
    let favoritesRepository: FavoritesRepository

    let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let getNowPlayingMoviesUseCase: GetNowPlayingMoviesUseCase
    let getTopRatedMoviesUseCase: GetTopRatedMoviesUseCase
    let getUpcomingMoviesUseCase: GetUpcomingMoviesUseCase
    let searchMoviesUseCase: SearchMoviesUseCase
    let getMovieDetailsUseCase: GetMovieDetailsUseCase
    let getMovieCreditsUseCase: GetMovieCreditsUseCase
    let getSimilarMoviesUseCase: GetSimilarMoviesUseCase
    let getMovieVideosUseCase: GetMovieVideosUseCase
    let getFavoritesUseCase: GetFavoritesUseCase
    let addFavoriteUseCase: AddFavoriteUseCase
    let removeFavoriteUseCase: RemoveFavoriteUseCase
    let isFavoriteUseCase: IsFavoriteUseCase

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
        getMovieDetailsUseCase = GetMovieDetailsUseCase(repository: movieRepository)
        getMovieCreditsUseCase = GetMovieCreditsUseCase(repository: movieRepository)
        getSimilarMoviesUseCase = GetSimilarMoviesUseCase(repository: movieRepository)
        getMovieVideosUseCase = GetMovieVideosUseCase(repository: movieRepository)

        // A failure here means the on-disk store is unusable (corrupt schema,
        // no disk space) — unrecoverable at runtime, so we fail fast at launch.
        let modelContainer = try! ModelContainer(for: FavoriteMovieModel.self)
        let favoritesLocalDataSource = SwiftDataFavoritesLocalDataSource(modelContext: modelContainer.mainContext)
        let favoritesRepository = FavoritesRepositoryImpl(localDataSource: favoritesLocalDataSource)

        self.modelContainer = modelContainer
        self.favoritesLocalDataSource = favoritesLocalDataSource
        self.favoritesRepository = favoritesRepository

        getFavoritesUseCase = GetFavoritesUseCase(repository: favoritesRepository)
        addFavoriteUseCase = AddFavoriteUseCase(repository: favoritesRepository)
        removeFavoriteUseCase = RemoveFavoriteUseCase(repository: favoritesRepository)
        isFavoriteUseCase = IsFavoriteUseCase(repository: favoritesRepository)
    }
}
