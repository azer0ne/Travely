import ComposableArchitecture
import Foundation

@Reducer
struct TripListFeature {
    @Dependency(\.tripRepository) var tripRepository

    @ObservableState
    struct State: Equatable {
        @Presents var createTrip: CreateTripFeature.State?
        var deletingTripID: Trip.ID?
        var errorMessage: String?
        var isLoading = false
        var tripPendingDeletion: Trip?
        var trips: [Trip] = []
    }

    enum Action {
        case createTrip(PresentationAction<CreateTripFeature.Action>)
        case deleteTripResponse(TaskResult<Trip.ID>)
        case delegate(DelegateAction)
        case tripsResponse(TaskResult<[Trip]>)
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case tripSelected(Trip)
    }

    enum ViewAction {
        case createTripButtonTapped
        case deleteTripConfirmationDismissed
        case deleteTripConfirmed
        case deleteTripTapped(Trip.ID)
        case onAppear
        case tripTapped(Trip.ID)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.createTripButtonTapped):
                state.createTrip = CreateTripFeature.State()
                return .none

            case let .view(.deleteTripTapped(tripID)):
                guard state.deletingTripID == nil,
                    let trip = state.trips.first(where: { $0.id == tripID })
                else {
                    return .none
                }

                state.tripPendingDeletion = trip
                return .none

            case .view(.deleteTripConfirmationDismissed):
                state.tripPendingDeletion = nil
                return .none

            case .view(.deleteTripConfirmed):
                guard let trip = state.tripPendingDeletion, state.deletingTripID == nil else {
                    return .none
                }

                state.tripPendingDeletion = nil
                state.deletingTripID = trip.id
                state.errorMessage = nil
                return .run { [tripID = trip.id] send in
                    await send(.deleteTripResponse(TaskResult {
                        try await tripRepository.deleteTrip(tripID)
                        return tripID
                    }))
                }

            case .view(.onAppear):
                guard !state.isLoading else {
                    return .none
                }

                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    await send(.tripsResponse(TaskResult {
                        try await tripRepository.fetchTrips()
                    }))
                }

            case let .view(.tripTapped(tripID)):
                guard let trip = state.trips.first(where: { $0.id == tripID }) else {
                    return .none
                }
                return .send(.delegate(.tripSelected(trip)))

            case let .tripsResponse(.success(trips)):
                state.isLoading = false
                state.trips = trips
                return .none

            case .tripsResponse(.failure):
                state.isLoading = false
                state.errorMessage = "Could not load trips."
                return .none

            case let .deleteTripResponse(.success(tripID)):
                state.deletingTripID = nil
                state.errorMessage = nil
                state.trips.removeAll { $0.id == tripID }
                return .none

            case .deleteTripResponse(.failure):
                state.deletingTripID = nil
                state.errorMessage = "Could not delete this trip."
                return .none

            case .createTrip(.presented(.delegate(.cancelled))):
                state.createTrip = nil
                return .none

            case .createTrip(.presented(.delegate(.tripCreated(let trip)))):
                state.createTrip = nil
                state.trips = (state.trips + [trip]).sorted { lhs, rhs in
                    lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
                }
                return .none

            case .createTrip:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$createTrip, action: \.createTrip) {
            CreateTripFeature()
        }
    }
}
