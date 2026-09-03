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

    func getMovieDetails(id: Int) async throws -> MovieDetails {
        MovieMapper.map(try await remoteDataSource.getMovieDetails(id: id))
    }

    func getMovieCredits(id: Int) async throws -> [CastMember] {
        CreditsMapper.map(try await remoteDataSource.getMovieCredits(id: id))
    }

    func getSimilarMovies(id: Int, page: Int) async throws -> [Movie] {
        MovieMapper.map(try await remoteDataSource.getSimilarMovies(id: id, page: page))
    }

    func getMovieVideos(id: Int) async throws -> [Video] {
        MovieMapper.map(try await remoteDataSource.getMovieVideos(id: id))
    }
}
