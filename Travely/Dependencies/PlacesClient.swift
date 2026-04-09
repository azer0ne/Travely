import ComposableArchitecture
import Foundation
import MapKit

struct PlacesClient {
    var autocomplete: @Sendable (_ query: String) async throws -> [Place]
    var search: @Sendable (_ query: String) async throws -> [Place]
}

extension PlacesClient: DependencyKey {
    static let liveValue = Self(
        autocomplete: { query in
            try await liveSearch(query: query)
        },
        search: { query in
            try await liveSearch(query: query)
        }
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

private extension PlacesClient {
    @MainActor
    static func liveSearch(query: String) async throws -> [Place] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return []
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = trimmedQuery

        let response = try await MKLocalSearch(request: request).start()

        return response.mapItems.reduce(into: []) { places, mapItem in
            guard let place = mapItem.asPlace else {
                return
            }

            guard !places.contains(where: { existingPlace in
                existingPlace.name == place.name
                    && existingPlace.address == place.address
                    && existingPlace.latitude == place.latitude
                    && existingPlace.longitude == place.longitude
            }) else {
                return
            }

            places.append(place)
        }
    }
}

private extension MKMapItem {
    var asPlace: Place? {
        let name = self.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !name.isEmpty else {
            return nil
        }

        let coordinate = placemark.coordinate
        return Place(
            name: name,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            address: placemark.travelyFormattedAddress,
            category: pointOfInterestCategory?.travelyDisplayName
        )
    }
}

private extension MKPlacemark {
    var travelyFormattedAddress: String {
        let addressComponents: [String] = [
            subThoroughfare,
            thoroughfare,
            locality,
            administrativeArea,
            postalCode,
            country
        ]
        .compactMap { component in
            guard let trimmedComponent = component?.trimmingCharacters(in: .whitespacesAndNewlines),
                !trimmedComponent.isEmpty
            else {
                return nil
            }

            return trimmedComponent
        }

        if !addressComponents.isEmpty {
            return addressComponents.joined(separator: ", ")
        }

        if let title = title?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty {
            return title
        }

        return "Address unavailable"
    }
}

private extension MKPointOfInterestCategory {
    var travelyDisplayName: String {
        rawValue
            .replacing("MKPOICategory", with: "")
            .replacing("_", with: " ")
    }
}
