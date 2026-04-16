import ComposableArchitecture
import Foundation
import Testing
@testable import Travely

@MainActor
struct AppFeatureTests {
    @Test
    func tripUpdateFromNestedFlowSynchronizesTripsSlice() async {
        let originalItem = ItineraryItem(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            title: "Museum Visit",
            category: .activity
        )
        var originalTrip = Trip(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!,
            name: "Paris",
            itineraryItems: [originalItem]
        )

        let updatedItem = ItineraryItem(
            id: originalItem.id,
            title: "Louvre Museum Visit",
            category: .activity
        )
        originalTrip.itineraryItems = [originalItem]

        var updatedTrip = originalTrip
        updatedTrip.itineraryItems = [updatedItem]

        var initialState = AppFeature.State()
        initialState.trips.trips = [originalTrip]
        initialState.path.append(.tripDetail(TripDetailFeature.State(trip: originalTrip)))
        initialState.path.append(.itineraryItemDetail(ItineraryItemDetailFeature.State(trip: originalTrip, itineraryItem: originalItem)))
        initialState.path.append(.tripMap(TripMapFeature.State(trip: originalTrip)))

        let pathIDs = Array(initialState.path.ids)
        let tripDetailID = pathIDs[0]
        let itineraryItemDetailID = pathIDs[1]
        let tripMapID = pathIDs[2]

        let store = TestStore(initialState: initialState) {
            AppFeature()
        }

        await store.send(
            AppFeature.Action.path(
                .element(
                    id: itineraryItemDetailID,
                    action: .itineraryItemDetail(.delegate(.tripUpdated(updatedTrip)))
                )
            )
        ) {
            $0.trips.trips = [updatedTrip]

            var tripDetailState = $0.path[id: tripDetailID, case: \.tripDetail]!
            tripDetailState.trip = updatedTrip
            tripDetailState.updateItineraryItems(updatedTrip.itineraryItems)
            $0.path[id: tripDetailID, case: \.tripDetail] = tripDetailState

            var itineraryItemDetailState = $0.path[id: itineraryItemDetailID, case: \.itineraryItemDetail]!
            itineraryItemDetailState.trip = updatedTrip
            itineraryItemDetailState.itineraryItem = updatedItem
            $0.path[id: itineraryItemDetailID, case: \.itineraryItemDetail] = itineraryItemDetailState

            var tripMapState = $0.path[id: tripMapID, case: \.tripMap]!
            tripMapState.trip = updatedTrip
            tripMapState.updateItineraryItems(updatedTrip.itineraryItems)
            $0.path[id: tripMapID, case: \.tripMap] = tripMapState
        }
    }
}
