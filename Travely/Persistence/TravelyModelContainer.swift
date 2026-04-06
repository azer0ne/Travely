import SwiftData

enum TravelyModelContainer {
    static func make(isStoredInMemoryOnly: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        return try ModelContainer(
            for: TripEntity.self,
            ItineraryItemEntity.self,
            configurations: configuration
        )
    }
}
