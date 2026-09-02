nonisolated enum MovieMapper {
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

    static func map(_ dto: GenreDTO) -> Genre {
        Genre(id: dto.id, name: dto.name)
    }

    static func map(_ dto: MovieDetailsDTO) -> MovieDetails {
        MovieDetails(
            id: dto.id,
            title: dto.title,
            tagline: dto.tagline ?? "",
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            rating: dto.voteAverage,
            voteCount: dto.voteCount,
            releaseDate: dto.releaseDate ?? "",
            runtime: dto.runtime,
            genres: dto.genres.map(map)
        )
    }

    static func map(_ dto: VideoDTO) -> Video {
        Video(id: dto.id, name: dto.name, site: dto.site, key: dto.key, type: dto.type)
    }

    static func map(_ dtos: [VideoDTO]) -> [Video] {
        dtos.map(map)
    }
}
