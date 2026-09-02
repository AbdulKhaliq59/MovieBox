import Foundation


enum ImageLoader {
    static func url(path: String?, size: String) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        return URL(string: AppConfiguration.tmdbImageBaseURL + "/" + size + path)
    }
}
