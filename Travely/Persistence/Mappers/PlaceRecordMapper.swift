import Foundation

extension PlaceRecord {
    convenience init(place: Place) {
        self.init(
            id: place.id,
            name: place.name,
            latitude: place.latitude,
            longitude: place.longitude,
            address: place.address,
            category: place.category
        )
    }

    func update(from place: Place) {
        id = place.id
        name = place.name
        latitude = place.latitude
        longitude = place.longitude
        address = place.address
        category = place.category
    }

    func toDomain() -> Place {
        Place(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            address: address,
            category: category
        )
    }
}

extension Place {
    func toRecord() -> PlaceRecord {
        PlaceRecord(place: self)
    }
}
