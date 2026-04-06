import ComposableArchitecture
import CoreLocation
import Foundation

struct LocationClient {
    var currentCoordinates: @Sendable () async throws -> (latitude: Double, longitude: Double)?
}

extension LocationClient: DependencyKey {
    static let liveValue = Self(
        currentCoordinates: {
            try await CoreLocationOneShotRequest().currentCoordinates()
        }
    )

    static let previewValue = Self(
        currentCoordinates: { nil }
    )

    static let testValue = Self(
        currentCoordinates: { nil }
    )
}

extension DependencyValues {
    var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}
