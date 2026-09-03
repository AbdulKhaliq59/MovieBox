struct GetMovieVideosUseCase: Sendable {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> [Video] {
        try await repository.getMovieVideos(id: id)
    }
}
