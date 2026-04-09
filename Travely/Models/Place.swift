import Foundation

struct Place: Equatable, Identifiable, Sendable {
    let id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String
    var category: String?

    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        address: String,
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
