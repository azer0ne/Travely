import ComposableArchitecture

@Reducer
struct PlaceMapFeature {
    @ObservableState
    struct State: Equatable {
        var place: Place
    }

    enum Action {
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
