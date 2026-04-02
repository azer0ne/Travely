import SwiftUI

struct ItineraryCategoryBadgeView: View {
    let category: ItineraryItemCategory

    var body: some View {
        Text(category.title.uppercased())
            .font(.caption)
            .bold()
            .foregroundStyle(.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.88))
            .clipShape(.capsule)
    }
}
