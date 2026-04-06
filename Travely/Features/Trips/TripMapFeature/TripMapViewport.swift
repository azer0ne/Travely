import Foundation

struct TripMapViewport: Equatable, Hashable, Sendable {
    struct Coordinate: Equatable, Hashable, Sendable {
        var latitude: Double
        var longitude: Double
    }

    var center: Coordinate
    var latitudeDelta: Double
    var longitudeDelta: Double

    static let empty = TripMapViewport(
        center: Coordinate(latitude: 0, longitude: 0),
        latitudeDelta: 0.2,
        longitudeDelta: 0.2
    )

    static func fitting(_ coordinates: [Coordinate]) -> TripMapViewport {
        guard let firstCoordinate = coordinates.first else {
            return .empty
        }

        guard coordinates.count > 1 else {
            return TripMapViewport(
                center: firstCoordinate,
                latitudeDelta: 0.015,
                longitudeDelta: 0.015
            )
        }

        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)

        let minLatitude = latitudes.min() ?? firstCoordinate.latitude
        let maxLatitude = latitudes.max() ?? firstCoordinate.latitude
        let minLongitude = longitudes.min() ?? firstCoordinate.longitude
        let maxLongitude = longitudes.max() ?? firstCoordinate.longitude

        let latitudePadding = max((maxLatitude - minLatitude) * 0.45, 0.01)
        let longitudePadding = max((maxLongitude - minLongitude) * 0.45, 0.01)

        return TripMapViewport(
            center: Coordinate(
                latitude: (minLatitude + maxLatitude) / 2,
                longitude: (minLongitude + maxLongitude) / 2
            ),
            latitudeDelta: (maxLatitude - minLatitude) + latitudePadding,
            longitudeDelta: (maxLongitude - minLongitude) + longitudePadding
        )
    }
}
