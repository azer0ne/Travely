import ComposableArchitecture
import SwiftUI
import SwiftData

@main
struct TravelyApp: App {
    private let modelContainer: ModelContainer
    private let store: StoreOf<AppFeature>

    init() {
        do {
            let modelContainer = try TravelyModelContainer.make()
            self.modelContainer = modelContainer
            self.store = Store(initialState: AppFeature.State()) {
                AppFeature()
            } withDependencies: {
                $0.tripRepository = .live(modelContainer: modelContainer)
            }
        } catch {
            fatalError("Failed to initialize SwiftData: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
        .modelContainer(modelContainer)
    }
}
