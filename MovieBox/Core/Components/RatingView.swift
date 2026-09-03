import SwiftUI

struct RatingView: View {
    let rating: Double

    var body: some View {
        Label(String(format: "%.1f", rating), systemImage: "star.fill")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.yellow)
            .accessibilityLabel("Rating \(String(format: "%.1f", rating)) out of 10")
    }
}
