enum MovieMapper {
    static func map(_ dto: MovieDTO) -> Movie {
        Movie(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            rating: dto.voteAverage,
            voteCount: dto.voteCount,
            releaseDate: dto.releaseDate ?? ""
        )
    }

    static func map(_ dtos: [MovieDTO]) -> [Movie] {
        dtos.map(map)
    }
}
