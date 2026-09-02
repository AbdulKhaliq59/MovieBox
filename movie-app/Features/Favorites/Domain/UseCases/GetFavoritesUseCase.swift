struct GetFavoritesUseCase: Sendable {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Movie] {
        try await repository.getFavorites()
    }
}
