import SwiftUI

struct CachedAsyncImage: View {
    let path: String?
    let size: String
    var contentMode: ContentMode = .fill

    var body: some View {
        AsyncImage(url: ImageLoader.url(path: path, size: size)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                placeholder(showIcon: true)
            case .empty:
                placeholder(showIcon: false)
            @unknown default:
                placeholder(showIcon: false)
            }
        }
    }

    private func placeholder(showIcon: Bool) -> some View {
        ZStack {
            Rectangle().fill(.tertiary.opacity(0.3))
            if showIcon {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
