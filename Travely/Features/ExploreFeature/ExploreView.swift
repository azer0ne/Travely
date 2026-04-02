import ComposableArchitecture
import SwiftUI

struct ExploreView: View {
    @Bindable var store: StoreOf<ExploreFeature>

    var body: some View {
        ContentUnavailableView(
            "Explore",
            systemImage: "globe",
            description: Text("Placeholder for featured destinations and discovery.")
        )
        .navigationTitle("Explore")
    }
}

#Preview {
    NavigationStack {
        ExploreView(
            store: Store(initialState: ExploreFeature.State()) {
                ExploreFeature()
            }
        )
    }
}
