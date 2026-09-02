import Foundation

enum TMDBEndpoint {
    case trending
    case popular(page: Int)
    case nowPlaying(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
    case search(query: String, page: Int)
    case details(id: Int)
    case credits(id: Int)
    case similar(id: Int, page: Int)
    case videos(id: Int)
}

extension TMDBEndpoint: APIEndpoint {
    var path: String {
        switch self {
        case .trending: "/trending/movie/day"
        case .popular: "/movie/popular"
        case .nowPlaying: "/movie/now_playing"
        case .topRated: "/movie/top_rated"
        case .upcoming: "/movie/upcoming"
        case .search: "/search/movie"
        case .details(let id): "/movie/\(id)"
        case .credits(let id): "/movie/\(id)/credits"
        case .similar(let id, _): "/movie/\(id)/similar"
        case .videos(let id): "/movie/\(id)/videos"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .trending, .details, .credits, .videos:
            []
        case .popular(let page), .nowPlaying(let page), .topRated(let page), .upcoming(let page):
            [URLQueryItem(name: "page", value: String(page))]
        case .search(let query, let page):
            [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page))
            ]
        case .similar(_, let page):
            [URLQueryItem(name: "page", value: String(page))]
        }
    }
}
