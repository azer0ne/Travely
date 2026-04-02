import Foundation
import SwiftData

@Model
final class TripRecord {
    var id: UUID
    var imageData: Data?
    var name: String
    var startDate: Date?
    var endDate: Date?
    var itineraryItems: [ItineraryItemRecord]?

    init(
        id: UUID = UUID(),
        imageData: Data? = nil,
        name: String = "",
        startDate: Date? = nil,
        endDate: Date? = nil,
        itineraryItems: [ItineraryItemRecord]? = []
    ) {
        self.id = id
        self.imageData = imageData
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.itineraryItems = itineraryItems
    }
}
