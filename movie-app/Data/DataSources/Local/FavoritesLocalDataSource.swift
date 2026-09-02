import Foundation
import SwiftData

protocol FavoritesLocalDataSource: Sendable {
    func getFavorites() throws -> [FavoriteMovieModel]
    func isFavorite(id: Int) throws -> Bool
    func addFavorite(_ model: FavoriteMovieModel) throws
    func removeFavorite(id: Int) throws
}

final class SwiftDataFavoritesLocalDataSource: FavoritesLocalDataSource, @unchecked Sendable {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getFavorites() throws -> [FavoriteMovieModel] {
        let descriptor = FetchDescriptor<FavoriteMovieModel>(sortBy: [SortDescriptor(\.addedAt, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }

    func isFavorite(id: Int) throws -> Bool {
        let descriptor = FetchDescriptor<FavoriteMovieModel>(predicate: #Predicate { $0.id == id })
        return try modelContext.fetchCount(descriptor) > 0
    }

    func addFavorite(_ model: FavoriteMovieModel) throws {
        guard try !isFavorite(id: model.id) else { return }
        modelContext.insert(model)
        try modelContext.save()
    }

    func removeFavorite(id: Int) throws {
        let descriptor = FetchDescriptor<FavoriteMovieModel>(predicate: #Predicate { $0.id == id })
        if let existing = try modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try modelContext.save()
        }
    }
}
