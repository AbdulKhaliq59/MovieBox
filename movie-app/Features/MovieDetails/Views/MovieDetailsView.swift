import SwiftUI

struct MovieDetailsView: View {
    @State private var viewModel: MovieDetailsViewModel

    init(viewModel: MovieDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                switch viewModel.loadingState {
                case .loading:
                    LoadingView()
                        .frame(height: 200)
                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadIfNeeded() }
                    }
                    .frame(height: 200)
                case .loaded:
                    content
                }
            }
            .padding(.bottom, 24)
        }
        .navigationTitle(viewModel.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await viewModel.toggleFavorite() }
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isFavorite ? .red : .primary)
                }
                .accessibilityLabel(viewModel.isFavorite ? "Remove from Favorites" : "Add to Favorites")
            }
        }
        .task { await viewModel.loadIfNeeded() }
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            CachedAsyncImage(path: viewModel.movie.backdropPath, size: AppConfiguration.ImageSize.backdrop)
                .frame(height: 240)
                .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .center, endPoint: .bottom)
        }
        .frame(height: 240)
    }

    @ViewBuilder
    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.movie.title)
                    .font(.title.bold())

                if let tagline = viewModel.details?.tagline, !tagline.isEmpty {
                    Text(tagline)
                        .font(.subheadline)
                        .italic()
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 12) {
                    RatingView(rating: viewModel.movie.rating)
                    if let runtime = viewModel.details?.runtime, runtime > 0 {
                        Label("\(runtime) min", systemImage: "clock")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if !viewModel.movie.releaseDate.isEmpty {
                        Text(String(viewModel.movie.releaseDate.prefix(4)))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if let genres = viewModel.details?.genres, !genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(genres) { genre in
                                Text(genre.name)
                                    .font(.caption.weight(.medium))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.tertiary.opacity(0.3), in: Capsule())
                            }
                        }
                    }
                }

                if let trailer = viewModel.trailer, let url = trailer.youtubeURL {
                    Link(destination: url) {
                        Label("Watch Trailer", systemImage: "play.circle.fill")
                            .font(.subheadline.weight(.semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 4)
                }

                Text(viewModel.movie.overview)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .padding(.horizontal)

            if !viewModel.cast.isEmpty {
                CastView(cast: viewModel.cast)
            }

            if !viewModel.similarMovies.isEmpty {
                SimilarMoviesView(movies: viewModel.similarMovies)
            }
        }
    }
}
