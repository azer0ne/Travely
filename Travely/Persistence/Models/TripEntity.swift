import Foundation
import SwiftData

@Model
final class TripEntity {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var imageData: Data?
    var name: String
    var startDate: Date?
    var endDate: Date?

    @Relationship(deleteRule: .cascade, inverse: \ItineraryItemEntity.trip)
    var itineraryItems: [ItineraryItemEntity]

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        imageData: Data? = nil,
        name: String = "",
        startDate: Date? = nil,
        endDate: Date? = nil,
        itineraryItems: [ItineraryItemEntity] = []
    ) {
        self.id = id
        self.createdAt = createdAt
        self.imageData = imageData
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.itineraryItems = itineraryItems
    }
}
