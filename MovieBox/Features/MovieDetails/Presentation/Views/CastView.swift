import SwiftUI

struct CastView: View {
    let cast: [CastMember]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cast")
                .font(.title3.bold())
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(cast) { member in
                        VStack(spacing: 6) {
                            CachedAsyncImage(path: member.profilePath, size: AppConfiguration.ImageSize.posterSmall)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .accessibilityHidden(true)

                            Text(member.name)
                                .font(.caption.weight(.medium))
                                .lineLimit(1)
                                .frame(width: 80)

                            Text(member.character)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .frame(width: 80)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
