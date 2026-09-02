import SwiftUI

struct SearchResultsView: View {
    let viewModel: SearchViewModel

    private let columns = [GridItem(.adaptive(minimum: 140), spacing: 16)]

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle:
                Color.clear
            case .loading:
                MovieGridSkeleton()
            case .error(let message):
                ErrorView(message: message) {
                    Task { await viewModel.onQueryChanged() }
                }
            case .empty:
                EmptyStateView(
                    systemImage: "magnifyingglass",
                    title: "No movies found",
                    message: "Try searching for another title."
                )
            case .loaded:
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.results) { movie in
                            NavigationLink(value: movie) {
                                MovieCard(movie: movie, width: 140)
                            }
                            .buttonStyle(.plain)
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                            .task {
                                await viewModel.loadNextPageIfNeeded(currentItem: movie)
                            }
                        }
                    }
                    .padding()
                    .animation(.easeOut(duration: 0.2), value: viewModel.results)

                    if viewModel.isLoadingNextPage {
                        ProgressView()
                            .padding()
                    }
                }
                .refreshable {
                    await viewModel.onQueryChanged()
                }
            }
        }
    }
}
