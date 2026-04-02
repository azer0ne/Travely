import Foundation

extension TripRecord {
    convenience init(trip: Trip) {
        self.init(
            id: trip.id,
            imageData: trip.imageData,
            name: trip.name,
            startDate: trip.startDate,
            endDate: trip.endDate
        )
        itineraryItems = trip.itineraryItems.map { ItineraryItemRecord(item: $0, trip: self) }
    }

    func update(from trip: Trip) {
        id = trip.id
        imageData = trip.imageData
        name = trip.name
        startDate = trip.startDate
        endDate = trip.endDate

        let existingItemsByID = Dictionary(
            uniqueKeysWithValues: (itineraryItems ?? []).map { ($0.id, $0) }
        )

        itineraryItems = trip.itineraryItems.map { item in
            if let existing = existingItemsByID[item.id] {
                existing.update(from: item, trip: self)
                return existing
            } else {
                return ItineraryItemRecord(item: item, trip: self)
            }
        }
    }

    func toDomain() -> Trip {
        Trip(
            id: id,
            imageData: imageData,
            name: name,
            startDate: startDate,
            endDate: endDate,
            itineraryItems: (itineraryItems ?? []).map { $0.toDomain() }
        )
    }
}

extension Trip {
    func toRecord() -> TripRecord {
        TripRecord(trip: self)
    }
}
