protocol MovieRemoteDataSource: Sendable {
    func getTrendingMovies() async throws -> [MovieDTO]
    func getPopularMovies(page: Int) async throws -> [MovieDTO]
    func getNowPlayingMovies(page: Int) async throws -> [MovieDTO]
    func getTopRatedMovies(page: Int) async throws -> [MovieDTO]
    func getUpcomingMovies(page: Int) async throws -> [MovieDTO]
    func searchMovies(query: String, page: Int) async throws -> [MovieDTO]

    func getMovieDetails(id: Int) async throws -> MovieDetailsDTO
    func getMovieCredits(id: Int) async throws -> [CastMemberDTO]
    func getSimilarMovies(id: Int, page: Int) async throws -> [MovieDTO]
    func getMovieVideos(id: Int) async throws -> [VideoDTO]
}

final class TMDBRemoteDataSource: MovieRemoteDataSource, @unchecked Sendable {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func getTrendingMovies() async throws -> [MovieDTO] {
        let response: PaginatedResponseDTO<MovieDTO> = try await apiClient.request(TMDBEndpoint.trending)
        return response.results
    }

    func getPopularMovies(page: Int) async throws -> [MovieDTO] {
        let response: PaginatedResponseDTO<MovieDTO> = try await apiClient.request(TMDBEndpoint.popular(page: page))
        return response.results
    }

    func getNowPlayingMovies(page: Int) async throws -> [MovieDTO] {
        let response: PaginatedResponseDTO<MovieDTO> = try await apiClient.request(TMDBEndpoint.nowPlaying(page: page))
        return response.results
    }

    func getTopRatedMovies(page: Int) async throws -> [MovieDTO] {
        let response: PaginatedResponseDTO<MovieDTO> = try await apiClient.request(TMDBEndpoint.topRated(page: page))
        return response.results
    }

    func getUpcomingMovies(page: Int) async throws -> [MovieDTO] {
        let response: PaginatedResponseDTO<MovieDTO> = try await apiClient.request(TMDBEndpoint.upcoming(page: page))
        return response.results
    }

    func searchMovies(query: String, page: Int) async throws -> [MovieDTO] {
        let response: PaginatedResponseDTO<MovieDTO> = try await apiClient.request(TMDBEndpoint.search(query: query, page: page))
        return response.results
    }

    func getMovieDetails(id: Int) async throws -> MovieDetailsDTO {
        try await apiClient.request(TMDBEndpoint.details(id: id))
    }

    func getMovieCredits(id: Int) async throws -> [CastMemberDTO] {
        let response: CreditsDTO = try await apiClient.request(TMDBEndpoint.credits(id: id))
        return response.cast
    }

    func getSimilarMovies(id: Int, page: Int) async throws -> [MovieDTO] {
        let response: PaginatedResponseDTO<MovieDTO> = try await apiClient.request(TMDBEndpoint.similar(id: id, page: page))
        return response.results
    }

    func getMovieVideos(id: Int) async throws -> [VideoDTO] {
        let response: VideosResponseDTO = try await apiClient.request(TMDBEndpoint.videos(id: id))
        return response.results
    }
}
