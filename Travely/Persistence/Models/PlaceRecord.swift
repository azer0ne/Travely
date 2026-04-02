import Foundation
import SwiftData

@Model
final class PlaceRecord {
    var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String
    var category: String?

    init(
        id: UUID = UUID(),
        name: String = "",
        latitude: Double = 0,
        longitude: Double = 0,
        address: String = "",
        category: String? = nil
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.category = category
    }
}
