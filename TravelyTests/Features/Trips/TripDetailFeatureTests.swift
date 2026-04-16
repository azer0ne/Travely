import ComposableArchitecture
import Foundation
import Testing
@testable import Travely

@MainActor
struct TripDetailFeatureTests {
    @Test
    func creatingItineraryItemUpdatesTripDetailAndDelegatesTripSync() async {
        let trip = Trip(
            id: UUID(uuidString: "30000000-0000-0000-0000-000000000001")!,
            name: "Seoul"
        )
        let item = ItineraryItem(
            id: UUID(uuidString: "30000000-0000-0000-0000-000000000002")!,
            title: "Bukchon Hanok Village",
            category: .activity
        )
        var updatedTrip = trip
        updatedTrip.itineraryItems = [item]

        var initialState = TripDetailFeature.State(trip: trip)
        initialState.createItineraryItem = CreateItineraryItemFeature.State(trip: trip)

        let store = TestStore(initialState: initialState) {
            TripDetailFeature()
        }

        await store.send(
            TripDetailFeature.Action.createItineraryItem(.presented(.delegate(.itineraryItemCreated(item))))
        ) {
            $0.createItineraryItem = nil
            $0.errorMessage = nil
            $0.updateItineraryItems([item])
        }

        await store.receive(\.delegate) {
            $0.trip = updatedTrip
            $0.itineraryItems = [item]
            $0.itinerarySections = TripDetailFeature.State.makeItinerarySections(from: [item])
        }
    }

    @Test
    func deletingItineraryItemRequiresConfirmationAndDelegatesTripSync() async {
        let item = ItineraryItem(
            id: UUID(uuidString: "40000000-0000-0000-0000-000000000001")!,
            title: "Dinner Reservation",
            category: .food
        )
        let trip = Trip(
            id: UUID(uuidString: "40000000-0000-0000-0000-000000000002")!,
            name: "Osaka",
            itineraryItems: [item]
        )
        var updatedTrip = trip
        updatedTrip.itineraryItems = []

        let store = TestStore(initialState: TripDetailFeature.State(trip: trip)) {
            TripDetailFeature()
        } withDependencies: {
            $0.tripRepository.deleteItineraryItem = { _, _ in }
        }

        await store.send(TripDetailFeature.Action.view(.deleteItineraryItemTapped(item.id))) {
            $0.itemPendingDeletion = item
        }

        await store.send(TripDetailFeature.Action.view(.deleteItineraryItemConfirmed)) {
            $0.itemPendingDeletion = nil
            $0.deletingItemID = item.id
            $0.errorMessage = nil
        }

        await store.receive(\.deleteItineraryItemResponse) {
            $0.deletingItemID = nil
            $0.errorMessage = nil
            $0.updateItineraryItems([])
        }

        await store.receive(\.delegate) {
            $0.trip = updatedTrip
            $0.itineraryItems = []
            $0.itinerarySections = []
        }
    }
}
