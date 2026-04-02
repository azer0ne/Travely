import ComposableArchitecture
import Foundation

struct PlacesClient {
    var autocomplete: @Sendable (_ query: String) async throws -> [Place]
    var search: @Sendable (_ query: String) async throws -> [Place]
}

extension PlacesClient: DependencyKey {
    static let liveValue = Self(
        autocomplete: { _ in [] },
        search: { _ in [] }
    )

    static let previewValue = Self(
        autocomplete: { _ in [] },
        search: { _ in [] }
    )

    static let testValue = Self(
        autocomplete: { _ in [] },
        search: { _ in [] }
    )
}

extension DependencyValues {
    var placesClient: PlacesClient {
        get { self[PlacesClient.self] }
        set { self[PlacesClient.self] = newValue }
    }
}
