import SwiftUI

struct MovieGridSkeleton: View {
    var count: Int = 6

    private let columns = [GridItem(.adaptive(minimum: 140), spacing: 16)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<count, id: \.self) { _ in
                    MovieCardSkeleton(width: 140)
                }
            }
            .padding()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading movies")
    }
}
