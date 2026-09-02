final class MovieRepositoryImpl: MovieRepository, @unchecked Sendable {
    private let remoteDataSource: MovieRemoteDataSource

    init(remoteDataSource: MovieRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getTrendingMovies() async throws -> [Movie] {
        MovieMapper.map(try await remoteDataSource.getTrendingMovies())
    }

    func getPopularMovies(page: Int) async throws -> [Movie] {
        MovieMapper.map(try await remoteDataSource.getPopularMovies(page: page))
    }

    func getNowPlayingMovies(page: Int) async throws -> [Movie] {
        MovieMapper.map(try await remoteDataSource.getNowPlayingMovies(page: page))
    }

    func getTopRatedMovies(page: Int) async throws -> [Movie] {
        MovieMapper.map(try await remoteDataSource.getTopRatedMovies(page: page))
    }

    func getUpcomingMovies(page: Int) async throws -> [Movie] {
        MovieMapper.map(try await remoteDataSource.getUpcomingMovies(page: page))
    }

    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        MovieMapper.map(try await remoteDataSource.searchMovies(query: query, page: page))
    }
}
