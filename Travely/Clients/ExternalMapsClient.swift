import ComposableArchitecture
import Foundation

struct ExternalMapsClient {
    var open: @Sendable (_ url: URL) async -> Void
}

extension ExternalMapsClient: DependencyKey {
    static let liveValue = Self(
        open: { _ in }
    )

    static let previewValue = Self(
        open: { _ in }
    )

    static let testValue = Self(
        open: { _ in }
    )
}

extension DependencyValues {
    var externalMapsClient: ExternalMapsClient {
        get { self[ExternalMapsClient.self] }
        set { self[ExternalMapsClient.self] = newValue }
    }
}
