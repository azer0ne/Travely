import Foundation
import SwiftData

@Model
final class ItineraryItemEntity {
    @Attribute(.unique) var id: UUID
    var title: String
    var categoryRawValue: String?
    var date: Date
    var time: Date
    var notes: String?
    var placeID: UUID?
    var placeName: String?
    var placeAddress: String?
    var placeLatitude: Double?
    var placeLongitude: Double?
    var placeCategory: String?

    var trip: TripEntity?

    init(
        id: UUID = UUID(),
        title: String = "",
        categoryRawValue: String? = nil,
        date: Date = .now,
        time: Date = .now,
        notes: String? = nil,
        placeID: UUID? = nil,
        placeName: String? = nil,
        placeAddress: String? = nil,
        placeLatitude: Double? = nil,
        placeLongitude: Double? = nil,
        placeCategory: String? = nil,
        trip: TripEntity? = nil
    ) {
        self.id = id
        self.title = title
        self.categoryRawValue = categoryRawValue
        self.date = date
        self.time = time
        self.notes = notes
        self.placeID = placeID
        self.placeName = placeName
        self.placeAddress = placeAddress
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.placeCategory = placeCategory
        self.trip = trip
    }
}
