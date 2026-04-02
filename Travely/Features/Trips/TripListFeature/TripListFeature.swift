import ComposableArchitecture
import Foundation

@Reducer
struct TripListFeature {
    @Dependency(\.tripRepository) var tripRepository

    @ObservableState
    struct State: Equatable {
        @Presents var createTrip: CreateTripFeature.State?
        var errorMessage: String?
        var isLoading = false
        var trips: [Trip] = []
    }

    enum Action {
        case createTrip(PresentationAction<CreateTripFeature.Action>)
        case delegate(DelegateAction)
        case tripsResponse(TaskResult<[Trip]>)
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case tripSelected(Trip)
    }

    enum ViewAction {
        case createTripButtonTapped
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
                state.errorMessage = nil
                return .run { send in
                    await send(.tripsResponse(TaskResult {
                        try await tripRepository.deleteTrip(tripID)
                        return try await tripRepository.fetchTrips()
                    }))
                }

            case .view(.onAppear):
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
