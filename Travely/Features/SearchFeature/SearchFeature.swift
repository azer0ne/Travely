import ComposableArchitecture

@Reducer
struct SearchFeature {
    @ObservableState
    struct State: Equatable {
        var query = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
    }

    enum ViewAction {
        case searchSubmitted
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .view(.searchSubmitted):
                return .none
            }
        }
    }
}
