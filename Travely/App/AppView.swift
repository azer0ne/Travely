import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            TabView(selection: $store.selectedTab) {
                Tab("Explore", systemImage: "globe", value: .explore) {
                    ExploreView(store: store.scope(state: \.explore, action: \.explore))
                }

                Tab("Search", systemImage: "magnifyingglass", value: .search) {
                    SearchView(store: store.scope(state: \.search, action: \.search))
                }

                Tab("Trips", systemImage: "suitcase", value: .trips) {
                    TripListView(store: store.scope(state: \.trips, action: \.trips))
                }

                Tab("Map", systemImage: "map", value: .map) {
                    MapView(store: store.scope(state: \.map, action: \.map))
                }
            }
        } destination: { store in
            switch store.case {
            case let .itineraryItemDetail(store):
                ItineraryItemDetailView(store: store)
            case let .tripDetail(store):
                TripDetailView(store: store)
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
