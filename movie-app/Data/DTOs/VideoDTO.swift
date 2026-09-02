struct VideoDTO: Decodable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}

struct VideosResponseDTO: Decodable {
    let results: [VideoDTO]
}
