final class FavoritesRepositoryImpl: FavoritesRepository, @unchecked Sendable {
    private let localDataSource: FavoritesLocalDataSource

    init(localDataSource: FavoritesLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func getFavorites() async throws -> [Movie] {
        FavoriteMovieMapper.map(try localDataSource.getFavorites())
    }

    func isFavorite(id: Int) async throws -> Bool {
        try localDataSource.isFavorite(id: id)
    }

    func addFavorite(_ movie: Movie) async throws {
        try localDataSource.addFavorite(FavoriteMovieMapper.map(movie))
    }

    func removeFavorite(id: Int) async throws {
        try localDataSource.removeFavorite(id: id)
    }
}
