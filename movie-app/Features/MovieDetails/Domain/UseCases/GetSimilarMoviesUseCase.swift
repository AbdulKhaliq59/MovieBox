struct GetSimilarMoviesUseCase: Sendable {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(id: Int, page: Int) async throws -> [Movie] {
        try await repository.getSimilarMovies(id: id, page: page)
    }
}
