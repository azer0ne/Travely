import Foundation

struct Trip: Equatable, Identifiable, Sendable {
    let id: UUID
    var imageData: Data?
    var name: String
    var startDate: Date?
    var endDate: Date?
    var itineraryItems: [ItineraryItem]

    init(
        id: UUID = UUID(),
        imageData: Data? = nil,
        name: String = "",
        startDate: Date? = nil,
        endDate: Date? = nil,
        itineraryItems: [ItineraryItem] = []
    ) {
        self.id = id
        self.imageData = imageData
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.itineraryItems = itineraryItems
    }
}
