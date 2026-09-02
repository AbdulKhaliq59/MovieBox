import Foundation

@Observable
@MainActor
final class SearchViewModel {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    var query: String = ""
    private(set) var results: [Movie] = []
    private(set) var loadingState: LoadingState = .idle
    private(set) var recentSearches: [String]
    private(set) var isLoadingNextPage = false

    private var currentPage = 1
    private var hasMorePages = true
    private var seenMovieIDs: Set<Int> = []

    private let searchMoviesUseCase: SearchMoviesUseCase
    private let recentSearchesStore: RecentSearchesStore

    init(searchMoviesUseCase: SearchMoviesUseCase, recentSearchesStore: RecentSearchesStore = RecentSearchesStore()) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.recentSearchesStore = recentSearchesStore
        self.recentSearches = recentSearchesStore.load()
    }

    /// Called from `.task(id: query)` — SwiftUI cancels the previous task
    /// whenever `query` changes, which gives us debouncing for free.
    func onQueryChanged() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            results = []
            loadingState = .idle
            return
        }

        loadingState = .loading
        try? await Task.sleep(nanoseconds: 400_000_000)
        guard !Task.isCancelled else { return }

        await performSearch(query: trimmed, page: 1)
    }

    func selectRecentSearch(_ term: String) async {
        query = term
        loadingState = .loading
        await performSearch(query: term, page: 1)
    }

    func removeRecentSearch(_ term: String) {
        recentSearchesStore.remove(term)
        recentSearches = recentSearchesStore.load()
    }

    func clearRecentSearches() {
        recentSearchesStore.clear()
        recentSearches = []
    }

    func loadNextPageIfNeeded(currentItem: Movie) async {
        guard hasMorePages, !isLoadingNextPage else { return }
        guard let index = results.firstIndex(where: { $0.id == currentItem.id }) else { return }
        guard index >= results.count - 5 else { return }

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isLoadingNextPage = true
        await performSearch(query: trimmed, page: currentPage + 1, append: true)
        isLoadingNextPage = false
    }

    private func performSearch(query: String, page: Int, append: Bool = false) async {
        do {
            let movies = try await searchMoviesUseCase.execute(query: query, page: page)

            if !append {
                results = []
                seenMovieIDs = []
            }
            let newMovies = movies.filter { !seenMovieIDs.contains($0.id) }
            newMovies.forEach { seenMovieIDs.insert($0.id) }
            results.append(contentsOf: newMovies)

            currentPage = page
            hasMorePages = movies.count >= AppConfiguration.defaultPageSize
            loadingState = results.isEmpty ? .empty : .loaded

            if !append {
                recentSearchesStore.add(query)
                recentSearches = recentSearchesStore.load()
            }
        } catch {
            if append {
                // Keep existing results visible; just stop paginating.
                hasMorePages = false
            } else {
                let message = (error as? NetworkError)?.userMessage
                    ?? NetworkError.unknown(description: error.localizedDescription).userMessage
                loadingState = .error(message)
            }
        }
    }
}
