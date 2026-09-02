struct GetMovieCreditsUseCase: Sendable {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> [CastMember] {
        try await repository.getMovieCredits(id: id)
    }
}
