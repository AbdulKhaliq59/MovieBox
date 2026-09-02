import Foundation

struct Video: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let site: String
    let key: String
    let type: String

    var isYouTubeTrailer: Bool {
        site == "YouTube" && type == "Trailer"
    }

    var youtubeURL: URL? {
        guard site == "YouTube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}
