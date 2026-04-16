import ComposableArchitecture
import Foundation
import Testing
@testable import Travely

@MainActor
struct CreateTripFeatureTests {
    @Test
    func saveRejectsEndDateBeforeStartDate() async {
        var initialState = CreateTripFeature.State()
        initialState.name = "Weekend Getaway"
        initialState.includesStartDate = true
        initialState.includesEndDate = true
        initialState.startDate = Date(timeIntervalSince1970: 1_800_000_000)
        initialState.endDate = Date(timeIntervalSince1970: 1_700_000_000)

        let store = TestStore(initialState: initialState) {
            CreateTripFeature()
        }

        await store.send(CreateTripFeature.Action.view(.saveTapped)) {
            $0.validationMessage = "End date must be on or after the start date."
        }
    }
}
