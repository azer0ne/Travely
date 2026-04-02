import ComposableArchitecture

@Reducer
struct TripMapFeature {
    @ObservableState
    struct State: Equatable {
        var trip: Trip?
    }

    enum Action {
        case view(ViewAction)
    }

    enum ViewAction {
        case onAppear
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
            }
        }
    }
}
