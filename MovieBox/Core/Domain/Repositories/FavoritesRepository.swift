protocol FavoritesRepository: Sendable {
    func getFavorites() async throws -> [Movie]
    func isFavorite(id: Int) async throws -> Bool
    func addFavorite(_ movie: Movie) async throws
    func removeFavorite(id: Int) async throws
}
