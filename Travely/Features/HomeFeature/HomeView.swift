import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    var body: some View {
        List {
            Button("Search Places", systemImage: "magnifyingglass") {
                store.send(.view(.searchTapped))
            }

            Button("Trip List", systemImage: "suitcase") {
                store.send(.view(.tripListTapped))
            }

            Button("Create Trip", systemImage: "plus.circle") {
                store.send(.view(.createTripTapped))
            }

            Button("Trip Detail", systemImage: "calendar") {
                store.send(.view(.tripDetailTapped))
            }

            Button("Place Detail", systemImage: "mappin.and.ellipse") {
                store.send(.view(.placeDetailTapped))
            }

            Button("Schedule Place", systemImage: "clock") {
                store.send(.view(.schedulePlaceTapped))
            }

            Button("Trip Map", systemImage: "map") {
                store.send(.view(.tripMapTapped))
            }
        }
        .navigationTitle("Travely")
    }
}

#Preview {
    NavigationStack {
        HomeView(
            store: Store(initialState: HomeFeature.State()) {
                HomeFeature()
            }
        )
    }
}
