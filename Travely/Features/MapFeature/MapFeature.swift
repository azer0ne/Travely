import ComposableArchitecture

@Reducer
struct MapFeature {
    @ObservableState
    struct State: Equatable {}

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
