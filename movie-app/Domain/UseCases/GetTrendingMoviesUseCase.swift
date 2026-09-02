struct GetTrendingMoviesUseCase: Sendable {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Movie] {
        try await repository.getTrendingMovies()
    }
}
