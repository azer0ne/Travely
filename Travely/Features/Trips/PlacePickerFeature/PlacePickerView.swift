import ComposableArchitecture
import SwiftUI

struct PlacePickerView: View {
    @Bindable var store: StoreOf<PlacePickerFeature>

    var body: some View {
        List {
            if store.isLoading {
                Section {
                    ProgressView("Searching")
                        .frame(maxWidth: .infinity)
                }
            } else if let errorMessage = store.errorMessage {
                Section {
                    ContentUnavailableView(
                        "Search Failed",
                        systemImage: "exclamationmark.magnifyingglass",
                        description: Text(errorMessage)
                    )
                }
            } else if store.showsInitialState {
                Section {
                    ContentUnavailableView(
                        "Search for a place",
                        systemImage: "mappin.and.ellipse",
                        description: Text("Attach a location to this itinerary item.")
                    )
                }
            } else if store.showsNoResults {
                Section {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text("Try a different search term.")
                    )
                }
            } else {
                Section("Results") {
                    ForEach(store.results) { place in
                        Button {
                            store.send(.view(.placeTapped(place)))
                        } label: {
                            PlacePickerResultRowView(place: place)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Add Location")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: Binding(
                get: { store.query },
                set: { store.send(.view(.queryChanged($0))) }
            ),
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search places"
        )
        .onSubmit(of: .search) {
            store.send(.view(.searchSubmitted))
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    store.send(.view(.cancelTapped))
                }
            }
        }
    }
}

#Preview("Empty") {
    NavigationStack {
        PlacePickerView(
            store: Store(initialState: PlacePickerFeature.State()) {
                PlacePickerFeature()
            }
        )
    }
}

#Preview("Results") {
    NavigationStack {
        PlacePickerView(
            store: Store(
                initialState: {
                    var state = PlacePickerFeature.State(query: "Paris")
                    state.hasSearched = true
                    state.results = [
                        Place(
                            name: "Louvre Museum",
                            latitude: 48.8606,
                            longitude: 2.3376,
                            address: "Rue de Rivoli, 75001 Paris, France",
                            category: "Museum"
                        ),
                        Place(
                            name: "Hotel Lutetia",
                            latitude: 48.8517,
                            longitude: 2.3255,
                            address: "45 Boulevard Raspail, 75006 Paris, France",
                            category: "Hotel"
                        )
                    ]
                    return state
                }()
            ) {
                PlacePickerFeature()
            }
        )
    }
}

#Preview("No Results") {
    NavigationStack {
        PlacePickerView(
            store: Store(
                initialState: {
                    var state = PlacePickerFeature.State(query: "zzzz")
                    state.hasSearched = true
                    return state
                }()
            ) {
                PlacePickerFeature()
            }
        )
    }
}
