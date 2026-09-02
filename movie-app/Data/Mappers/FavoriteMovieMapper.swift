nonisolated enum FavoriteMovieMapper {
    static func map(_ movie: Movie) -> FavoriteMovieModel {
        FavoriteMovieModel(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            rating: movie.rating,
            voteCount: movie.voteCount,
            releaseDate: movie.releaseDate
        )
    }

    static func map(_ model: FavoriteMovieModel) -> Movie {
        Movie(
            id: model.id,
            title: model.title,
            overview: model.overview,
            posterPath: model.posterPath,
            backdropPath: model.backdropPath,
            rating: model.rating,
            voteCount: model.voteCount,
            releaseDate: model.releaseDate
        )
    }

    static func map(_ models: [FavoriteMovieModel]) -> [Movie] {
        models.map(map)
    }
}
