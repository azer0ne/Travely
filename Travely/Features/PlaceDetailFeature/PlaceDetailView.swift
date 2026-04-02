import ComposableArchitecture
import SwiftUI

struct PlaceDetailView: View {
    @Bindable var store: StoreOf<PlaceDetailFeature>

    var body: some View {
        ContentUnavailableView(
            "Place Detail",
            systemImage: "mappin.square",
            description: Text("Placeholder for a selected place.")
        )
        .navigationTitle("Place Detail")
    }
}

#Preview {
    NavigationStack {
        PlaceDetailView(
            store: Store(initialState: PlaceDetailFeature.State()) {
                PlaceDetailFeature()
            }
        )
    }
}
