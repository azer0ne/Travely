import ComposableArchitecture
import Foundation
import Testing
@testable import Travely

@MainActor
struct ItineraryItemDetailFeatureTests {
    @Test
    func editingItemUpdatesLocalDetailAndDelegatesTripSync() async {
        let originalItem = ItineraryItem(
            id: UUID(uuidString: "50000000-0000-0000-0000-000000000001")!,
            title: "Check-in",
            category: .hotel
        )
        let trip = Trip(
            id: UUID(uuidString: "50000000-0000-0000-0000-000000000002")!,
            name: "Singapore",
            itineraryItems: [originalItem]
        )
        let updatedItem = ItineraryItem(
            id: originalItem.id,
            title: "Marina Bay Sands Check-in",
            category: .hotel
        )
        var updatedTrip = trip
        updatedTrip.itineraryItems = [updatedItem]

        var initialState = ItineraryItemDetailFeature.State(trip: trip, itineraryItem: originalItem)
        initialState.editItineraryItem = CreateItineraryItemFeature.State(trip: trip, itineraryItem: originalItem)

        let store = TestStore(initialState: initialState) {
            ItineraryItemDetailFeature()
        }

        await store.send(
            ItineraryItemDetailFeature.Action.editItineraryItem(.presented(.delegate(.itineraryItemUpdated(updatedItem))))
        ) {
            $0.editItineraryItem = nil
            $0.itineraryItem = updatedItem
            $0.trip.itineraryItems = [updatedItem]
        }

        await store.receive(\.delegate) {
            $0.trip = updatedTrip
            $0.itineraryItem = updatedItem
        }
    }
}
