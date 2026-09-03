import SwiftUI

struct MovieCardSkeleton: View {
    var width: CGFloat = 140

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            SkeletonBlock(cornerRadius: 12)
                .frame(width: width, height: width * 1.5)
            SkeletonBlock(cornerRadius: 4)
                .frame(width: width * 0.8, height: 14)
            SkeletonBlock(cornerRadius: 4)
                .frame(width: width * 0.5, height: 12)
        }
        .accessibilityHidden(true)
    }
}
