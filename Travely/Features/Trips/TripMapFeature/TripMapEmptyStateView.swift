import SwiftUI

struct TripMapEmptyStateView: View {
    var body: some View {
        ContentUnavailableView(
            "No Places on This Trip Yet",
            systemImage: "map",
            description: Text("Places attached to itinerary items will appear on this map.")
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appNeutral)
    }
}
