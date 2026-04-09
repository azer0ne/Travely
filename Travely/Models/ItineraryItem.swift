import Foundation

struct ItineraryItem: Equatable, Identifiable, Sendable {
    let id: UUID
    var title: String
    var category: ItineraryItemCategory?
    var date: Date
    var time: Date
    var notes: String
    var attachedPlace: Place?
    var tripID: Trip.ID?

    init(
        id: UUID = UUID(),
        title: String = "",
        category: ItineraryItemCategory? = nil,
        date: Date = .now,
        time: Date = .now,
        notes: String = "",
        attachedPlace: Place? = nil,
        tripID: Trip.ID? = nil
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.date = date
        self.time = time
        self.notes = notes
        self.attachedPlace = attachedPlace
        self.tripID = tripID
    }
}
