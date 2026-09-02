struct AddFavoriteUseCase: Sendable {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func execute(_ movie: Movie) async throws {
        try await repository.addFavorite(movie)
    }
}
