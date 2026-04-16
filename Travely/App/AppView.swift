import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            TripListView(store: store.scope(state: \.trips, action: \.trips))
                .tint(Color.appPrimary)
        } destination: { store in
            switch store.case {
            case let .itineraryItemDetail(store):
                ItineraryItemDetailView(store: store)
            case let .tripDetail(store):
                TripDetailView(store: store)
            case let .tripMap(store):
                TripMapView(store: store)
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
