import Foundation
import UIKit

enum ImageLoader {
    static func url(path: String?, size: String) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        return URL(string: AppConfiguration.tmdbImageBaseURL + "/" + size + path)
    }

    private static let session: URLSession = {
        let cache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024,
            diskPath: "tmdb_images"
        )
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()

    static func loadImage(from url: URL) async throws -> UIImage {
        if let cached = await ImageCache.shared.image(for: url) {
            return cached
        }
        let (data, _) = try await session.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        await ImageCache.shared.insert(image, for: url)
        return image
    }
}
