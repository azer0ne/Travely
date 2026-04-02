import ComposableArchitecture
import SwiftUI

struct SearchView: View {
    @Bindable var store: StoreOf<SearchFeature>

    var body: some View {
        Form {
            TextField("Search places", text: $store.query)
                .textInputAutocapitalization(.words)

            Text("Search placeholder")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Search")
    }
}

#Preview {
    NavigationStack {
        SearchView(
            store: Store(initialState: SearchFeature.State()) {
                SearchFeature()
            }
        )
    }
}
