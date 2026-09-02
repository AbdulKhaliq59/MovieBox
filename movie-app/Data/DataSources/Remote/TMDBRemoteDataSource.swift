protocol MovieRemoteDataSource: Sendable {
    func getTrendingMovies() async throws -> [MovieDTO]
    func getPopularMovies(page: Int) async throws -> [MovieDTO]
    func getNowPlayingMovies(page: Int) async throws -> [MovieDTO]
    func getTopRatedMovies(page: Int) async throws -> [MovieDTO]
    func getUpcomingMovies(page: Int) async throws -> [MovieDTO]
    func searchMovies(query: String, page: Int) async throws -> [MovieDTO]
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
}
