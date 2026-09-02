struct GetNowPlayingMoviesUseCase: Sendable {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> [Movie] {
        try await repository.getNowPlayingMovies(page: page)
    }
}
