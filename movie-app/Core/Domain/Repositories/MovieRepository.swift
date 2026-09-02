protocol MovieRepository: Sendable {
    func getTrendingMovies() async throws -> [Movie]
    func getPopularMovies(page: Int) async throws -> [Movie]
    func getNowPlayingMovies(page: Int) async throws -> [Movie]
    func getTopRatedMovies(page: Int) async throws -> [Movie]
    func getUpcomingMovies(page: Int) async throws -> [Movie]
    func searchMovies(query: String, page: Int) async throws -> [Movie]

    func getMovieDetails(id: Int) async throws -> MovieDetails
    func getMovieCredits(id: Int) async throws -> [CastMember]
    func getSimilarMovies(id: Int, page: Int) async throws -> [Movie]
    func getMovieVideos(id: Int) async throws -> [Video]
}
