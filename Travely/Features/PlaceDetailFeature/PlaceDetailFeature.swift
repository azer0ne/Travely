import ComposableArchitecture

@Reducer
struct PlaceDetailFeature {
    @ObservableState
    struct State: Equatable {
        var place: Place?
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
