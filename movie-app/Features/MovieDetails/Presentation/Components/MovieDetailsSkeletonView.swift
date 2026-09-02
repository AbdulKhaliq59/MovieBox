import SwiftUI

struct MovieDetailsSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                SkeletonBlock(cornerRadius: 4).frame(width: 220, height: 28)
                SkeletonBlock(cornerRadius: 4).frame(width: 140, height: 16)
                SkeletonBlock(cornerRadius: 4).frame(height: 16)
                SkeletonBlock(cornerRadius: 4).frame(height: 16)
                SkeletonBlock(cornerRadius: 4).frame(width: 180, height: 16)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                SkeletonBlock(cornerRadius: 4)
                    .frame(width: 80, height: 20)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<5, id: \.self) { _ in
                            VStack(spacing: 6) {
                                Circle()
                                    .fill(.tertiary.opacity(0.3))
                                    .shimmering()
                                    .frame(width: 80, height: 80)
                                SkeletonBlock(cornerRadius: 4)
                                    .frame(width: 70, height: 12)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading movie details")
    }
}
