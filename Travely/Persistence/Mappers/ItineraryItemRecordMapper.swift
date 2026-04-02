import Foundation

extension ItineraryItemRecord {
    convenience init(item: ItineraryItem, trip: TripRecord? = nil) {
        self.init(
            id: item.id,
            title: item.title,
            categoryRawValue: item.category?.rawValue,
            date: item.date,
            time: item.time,
            notes: item.notes,
            place: item.attachedPlace.map(PlaceRecord.init(place:)),
            trip: trip
        )
    }

    func update(from item: ItineraryItem, trip: TripRecord? = nil) {
        id = item.id
        title = item.title
        categoryRawValue = item.category?.rawValue
        date = item.date
        time = item.time
        notes = item.notes
        self.trip = trip

        if let attachedPlace = item.attachedPlace {
            if let place {
                place.update(from: attachedPlace)
            } else {
                place = PlaceRecord(place: attachedPlace)
            }
        } else {
            place = nil
        }
    }

    func toDomain() -> ItineraryItem {
        ItineraryItem(
            id: id,
            title: title,
            category: categoryRawValue.flatMap(ItineraryItemCategory.init(rawValue:)),
            date: date,
            time: time,
            notes: notes,
            attachedPlace: place?.toDomain(),
            tripID: trip?.id
        )
    }
}

extension ItineraryItem {
    func toRecord(trip: TripRecord? = nil) -> ItineraryItemRecord {
        ItineraryItemRecord(item: self, trip: trip)
    }
}
