import ComposableArchitecture
import SwiftUI

struct TripMapView: View {
    @Bindable var store: StoreOf<TripMapFeature>

    var body: some View {
        ContentUnavailableView(
            "Trip Map",
            systemImage: "map.circle",
            description: Text("Placeholder for itinerary pins on a map.")
        )
        .navigationTitle("Trip Map")
    }
}

#Preview {
    NavigationStack {
        TripMapView(
            store: Store(initialState: TripMapFeature.State()) {
                TripMapFeature()
            }
        )
    }
}
