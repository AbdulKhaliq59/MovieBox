import Foundation
import SwiftData

/// SwiftData persistence model. Distinct from the Domain `Movie` entity —
/// this stores enough fields to render a favorite offline, mapped to/from
/// `Movie` by `FavoriteMovieMapper`.
@Model
final class FavoriteMovieModel {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var rating: Double
    var voteCount: Int
    var releaseDate: String
    var addedAt: Date

    init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String?,
        backdropPath: String?,
        rating: Double,
        voteCount: Int,
        releaseDate: String,
        addedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.rating = rating
        self.voteCount = voteCount
        self.releaseDate = releaseDate
        self.addedAt = addedAt
    }
}
