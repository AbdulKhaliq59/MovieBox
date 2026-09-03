import SwiftUI

struct RecentSearchesView: View {
    let recentSearches: [String]
    let onSelect: (String) -> Void
    let onRemove: (String) -> Void
    let onClearAll: () -> Void

    var body: some View {
        if recentSearches.isEmpty {
            EmptyStateView(
                systemImage: "magnifyingglass",
                title: "Search for Movies",
                message: "Find your next favorite movie by title."
            )
        } else {
            List {
                Section {
                    ForEach(recentSearches, id: \.self) { term in
                        Button {
                            onSelect(term)
                        } label: {
                            Label(term, systemImage: "clock")
                        }
                        .foregroundStyle(.primary)
                    }
                    .onDelete { indexSet in
                        indexSet.map { recentSearches[$0] }.forEach(onRemove)
                    }
                } header: {
                    HStack {
                        Text("Recent Searches")
                        Spacer()
                        Button("Clear All", action: onClearAll)
                            .font(.caption)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}
