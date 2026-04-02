import ComposableArchitecture

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {}

    enum Action {
        case delegate(DelegateAction)
        case view(ViewAction)
    }

    enum DelegateAction {
        case openCreateTrip
        case openPlaceDetail
        case openSchedulePlace
        case openSearch
        case openTripDetail
        case openTripList
        case openTripMap
    }

    enum ViewAction {
        case createTripTapped
        case placeDetailTapped
        case schedulePlaceTapped
        case searchTapped
        case tripDetailTapped
        case tripListTapped
        case tripMapTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.createTripTapped):
                return .send(.delegate(.openCreateTrip))

            case .view(.placeDetailTapped):
                return .send(.delegate(.openPlaceDetail))

            case .view(.schedulePlaceTapped):
                return .send(.delegate(.openSchedulePlace))

            case .view(.searchTapped):
                return .send(.delegate(.openSearch))

            case .view(.tripDetailTapped):
                return .send(.delegate(.openTripDetail))

            case .view(.tripListTapped):
                return .send(.delegate(.openTripList))

            case .view(.tripMapTapped):
                return .send(.delegate(.openTripMap))

            case .delegate:
                return .none
            }
        }
    }
}
