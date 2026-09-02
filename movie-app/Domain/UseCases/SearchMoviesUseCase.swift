struct SearchMoviesUseCase: Sendable {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(query: String, page: Int) async throws -> [Movie] {
        try await repository.searchMovies(query: query, page: page)
    }
}
