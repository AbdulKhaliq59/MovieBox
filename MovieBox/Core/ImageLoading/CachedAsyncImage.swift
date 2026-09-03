import SwiftUI

struct CachedAsyncImage: View {
    let path: String?
    let size: String
    var contentMode: ContentMode = .fill

    @State private var uiImage: UIImage?
    @State private var didFail = false

    private var url: URL? { ImageLoader.url(path: path, size: size) }

    var body: some View {
        content
            .task(id: url) {
                await load()
            }
    }

    @ViewBuilder
    private var content: some View {
        if let uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else if didFail || url == nil {
            placeholder(showIcon: true)
        } else {
            placeholder(showIcon: false)
        }
    }

    private func load() async {
        guard let url else {
            didFail = true
            return
        }
        didFail = false
        uiImage = nil
        do {
            uiImage = try await ImageLoader.loadImage(from: url)
        } catch {
            didFail = true
        }
    }

    private func placeholder(showIcon: Bool) -> some View {
        ZStack {
            Rectangle().fill(.tertiary.opacity(0.3))
            if showIcon {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            } else {
                ProgressView()
            }
        }
    }
}
