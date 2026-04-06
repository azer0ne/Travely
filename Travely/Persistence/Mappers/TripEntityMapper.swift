import Foundation

extension TripEntity {
    convenience init(trip: Trip, createdAt: Date = .now) {
        self.init(
            id: trip.id,
            createdAt: createdAt,
            imageData: trip.imageData,
            name: trip.name,
            startDate: trip.startDate,
            endDate: trip.endDate
        )
        itineraryItems = trip.itineraryItems.map { ItineraryItemEntity(item: $0, trip: self) }
    }

    func update(from trip: Trip) {
        id = trip.id
        imageData = trip.imageData
        name = trip.name
        startDate = trip.startDate
        endDate = trip.endDate

        let existingItemsByID = Dictionary(
            uniqueKeysWithValues: itineraryItems.map { ($0.id, $0) }
        )

        itineraryItems = trip.itineraryItems.map { item in
            if let existing = existingItemsByID[item.id] {
                existing.update(from: item, trip: self)
                return existing
            } else {
                return ItineraryItemEntity(item: item, trip: self)
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
            itineraryItems: itineraryItems
                .map { $0.toDomain() }
                .sorted(by: Self.sortItems)
        )
    }

    private static func sortItems(lhs: ItineraryItem, rhs: ItineraryItem) -> Bool {
        if lhs.date != rhs.date {
            return lhs.date < rhs.date
        }

        return lhs.time < rhs.time
    }
}
