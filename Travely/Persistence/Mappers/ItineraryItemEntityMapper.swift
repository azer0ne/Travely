import Foundation

extension ItineraryItemEntity {
    convenience init(item: ItineraryItem, trip: TripEntity? = nil) {
        self.init(
            id: item.id,
            title: item.title,
            categoryRawValue: item.category?.rawValue,
            date: item.date,
            time: item.time,
            notes: item.notes.nilIfEmpty,
            trip: trip
        )
        updateAttachedPlace(from: item.attachedPlace)
    }

    func update(from item: ItineraryItem, trip: TripEntity? = nil) {
        id = item.id
        title = item.title
        categoryRawValue = item.category?.rawValue
        date = item.date
        time = item.time
        notes = item.notes.nilIfEmpty
        self.trip = trip ?? self.trip
        updateAttachedPlace(from: item.attachedPlace)
    }

    func toDomain() -> ItineraryItem {
        ItineraryItem(
            id: id,
            title: title,
            category: categoryRawValue.flatMap(ItineraryItemCategory.init(rawValue:)),
            date: date,
            time: time,
            notes: notes ?? "",
            attachedPlace: toAttachedPlace(),
            tripID: trip?.id
        )
    }

    private func updateAttachedPlace(from place: Place?) {
        placeID = place?.id
        placeName = place?.name
        placeAddress = place?.address
        placeLatitude = place?.latitude
        placeLongitude = place?.longitude
        placeCategory = place?.category
    }

    private func toAttachedPlace() -> Place? {
        guard let placeName, let placeAddress, let placeLatitude, let placeLongitude else {
            return nil
        }

        return Place(
            id: placeID ?? UUID(),
            name: placeName,
            latitude: placeLatitude,
            longitude: placeLongitude,
            address: placeAddress,
            category: placeCategory
        )
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
