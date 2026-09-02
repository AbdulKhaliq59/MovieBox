import SwiftUI

struct FeaturedMovieView: View {
    let movie: Movie

    var body: some View {
        NavigationLink(value: movie) {
            ZStack(alignment: .bottomLeading) {
                CachedAsyncImage(path: movie.backdropPath, size: AppConfiguration.ImageSize.backdrop)
                    .frame(height: 220)
                    .clipped()
                    .accessibilityHidden(true)

                LinearGradient(
                    colors: [.clear, .black.opacity(0.75)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    RatingView(rating: movie.rating)
                }
                .padding()
            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            .accessibilityElement(children: .combine)
        }
        .buttonStyle(.plain)
    }
}
