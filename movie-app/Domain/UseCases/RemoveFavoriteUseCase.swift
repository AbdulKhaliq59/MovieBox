struct RemoveFavoriteUseCase: Sendable {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws {
        try await repository.removeFavorite(id: id)
    }
}
