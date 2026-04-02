import ComposableArchitecture
import Foundation

struct DirectionsClient {
    var directionsURL: @Sendable (_ destination: Place) -> URL?
}

extension DirectionsClient: DependencyKey {
    static let liveValue = Self(
        directionsURL: { _ in nil }
    )

    static let previewValue = Self(
        directionsURL: { _ in nil }
    )

    static let testValue = Self(
        directionsURL: { _ in nil }
    )
}

extension DependencyValues {
    var directionsClient: DirectionsClient {
        get { self[DirectionsClient.self] }
        set { self[DirectionsClient.self] = newValue }
    }
}
