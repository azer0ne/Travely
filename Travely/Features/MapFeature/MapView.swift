import ComposableArchitecture
import SwiftUI

struct MapView: View {
    @Bindable var store: StoreOf<MapFeature>

    var body: some View {
        ContentUnavailableView(
            "Map",
            systemImage: "map",
            description: Text("Placeholder for map-based exploration.")
        )
        .navigationTitle("Map")
    }
}

#Preview {
    NavigationStack {
        MapView(
            store: Store(initialState: MapFeature.State()) {
                MapFeature()
            }
        )
    }
}
