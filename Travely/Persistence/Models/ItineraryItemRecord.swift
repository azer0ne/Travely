import Foundation
import SwiftData

@Model
final class ItineraryItemRecord {
    var id: UUID
    var title: String
    var categoryRawValue: String?
    var date: Date
    var time: Date
    var notes: String
    var place: PlaceRecord?
    var trip: TripRecord?

    init(
        id: UUID = UUID(),
        title: String = "",
        categoryRawValue: String? = nil,
        date: Date = .now,
        time: Date = .now,
        notes: String = "",
        place: PlaceRecord? = nil,
        trip: TripRecord? = nil
    ) {
        self.id = id
        self.title = title
        self.categoryRawValue = categoryRawValue
        self.date = date
        self.time = time
        self.notes = notes
        self.place = place
        self.trip = trip
    }
}
