struct IsFavoriteUseCase: Sendable {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> Bool {
        try await repository.isFavorite(id: id)
    }
}
