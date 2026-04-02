import ComposableArchitecture
import SwiftUI

struct LocationSearchView: View {
    @Bindable var store: StoreOf<LocationSearchFeature>

    var body: some View {
        List {
            Section {
                TextField("Search places", text: $store.query)
                    .textInputAutocapitalization(.words)
            }

            if store.isSearching {
                Section {
                    ProgressView("Searching")
                }
            } else if let errorMessage = store.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            } else if !store.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && store.results.isEmpty {
                Section {
                    ContentUnavailableView.search
                }
            } else if !store.results.isEmpty {
                Section("Results") {
                    ForEach(store.results) { place in
                        Button {
                            store.send(.view(.placeTapped(place)))
                        } label: {
                            VStack(alignment: .leading) {
                                Text(place.name)
                                    .foregroundStyle(.primary)
                                Text(place.address)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Add Location")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    store.send(.view(.cancelTapped))
                }
            }
        }
    }
}
