struct GetMovieDetailsUseCase: Sendable {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> MovieDetails {
        try await repository.getMovieDetails(id: id)
    }
}
