import Foundation

/// Lightweight local persistence for recent search terms via `UserDefaults`.
/// Distinct from the Favorites SwiftData store — this only remembers query
/// strings, not whole movies.
nonisolated struct RecentSearchesStore {
    private let key = "recentSearches"
    private let maxCount = 10
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> [String] {
        defaults.stringArray(forKey: key) ?? []
    }

    func add(_ term: String) {
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var current = load()
        current.removeAll { $0.caseInsensitiveCompare(trimmed) == .orderedSame }
        current.insert(trimmed, at: 0)
        if current.count > maxCount {
            current = Array(current.prefix(maxCount))
        }
        defaults.set(current, forKey: key)
    }

    func remove(_ term: String) {
        var current = load()
        current.removeAll { $0 == term }
        defaults.set(current, forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
