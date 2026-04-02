import ComposableArchitecture
import SwiftUI

struct SchedulePlaceView: View {
    @Bindable var store: StoreOf<SchedulePlaceFeature>

    var body: some View {
        ContentUnavailableView(
            "Schedule Place",
            systemImage: "clock.badge",
            description: Text("Placeholder for assigning a place to a trip.")
        )
        .navigationTitle("Schedule")
    }
}

#Preview {
    NavigationStack {
        SchedulePlaceView(
            store: Store(initialState: SchedulePlaceFeature.State()) {
                SchedulePlaceFeature()
            }
        )
    }
}
