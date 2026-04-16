import ComposableArchitecture
import Foundation
import Testing
@testable import Travely

@MainActor
struct TripListFeatureTests {
    @Test
    func deleteTripRequiresConfirmationAndRemovesTrip() async {
        let trip = Trip(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000001")!,
            name: "Tokyo"
        )

        let store = TestStore(initialState: TripListFeature.State(trips: [trip])) {
            TripListFeature()
        } withDependencies: {
            $0.tripRepository.deleteTrip = { _ in }
        }

        await store.send(TripListFeature.Action.view(.deleteTripTapped(trip.id))) {
            $0.tripPendingDeletion = trip
        }

        await store.send(TripListFeature.Action.view(.deleteTripConfirmed)) {
            $0.tripPendingDeletion = nil
            $0.deletingTripID = trip.id
            $0.errorMessage = nil
        }

        await store.receive(\.deleteTripResponse) {
            $0.deletingTripID = nil
            $0.errorMessage = nil
            $0.trips = []
        }
    }
}
