import SwiftUI

struct HomeSkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                SkeletonBlock(cornerRadius: 16)
                    .frame(height: 220)
                    .padding(.horizontal)

                ForEach(0..<4, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: 12) {
                        SkeletonBlock(cornerRadius: 4)
                            .frame(width: 120, height: 20)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<4, id: \.self) { _ in
                                    MovieCardSkeleton()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading movies")
    }
}
