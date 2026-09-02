struct MovieDetailsDTO: Decodable {
    let id: Int
    let title: String
    let tagline: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String?
    let runtime: Int?
    let genres: [GenreDTO]
}
