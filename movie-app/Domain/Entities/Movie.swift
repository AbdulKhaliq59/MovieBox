struct Movie: Identifiable, Equatable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let rating: Double
    let voteCount: Int
    let releaseDate: String
}
