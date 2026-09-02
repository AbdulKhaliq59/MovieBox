import SwiftUI

struct MovieCard: View {
    let movie: Movie
    var width: CGFloat = 140

    private var releaseYear: String {
        String(movie.releaseDate.prefix(4))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            CachedAsyncImage(path: movie.posterPath, size: AppConfiguration.ImageSize.posterMedium)
                .frame(width: width, height: width * 1.5)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(movie.title)
                .font(.subheadline.weight(.medium))
                .lineLimit(2)
                .frame(width: width, alignment: .leading)

            HStack(spacing: 4) {
                RatingView(rating: movie.rating)
                if !releaseYear.isEmpty {
                    Text(releaseYear)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: width, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}
