import ComposableArchitecture
import Foundation

@Reducer
struct LocationSearchFeature {
    @Dependency(\.continuousClock) var clock
    @Dependency(\.placesClient) var placesClient

    private enum CancelID {
        case search
    }

    @ObservableState
    struct State: Equatable {
        var errorMessage: String?
        var isSearching = false
        var query = ""
        var results: [Place] = []

        init(query: String = "") {
            self.query = query
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case delegate(DelegateAction)
        case searchResponse(TaskResult<[Place]>)
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case cancelled
        case placeSelected(Place)
    }

    enum ViewAction: Equatable {
        case cancelTapped
        case placeTapped(Place)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.query):
                let trimmedQuery = state.query.trimmingCharacters(in: .whitespacesAndNewlines)
                state.errorMessage = nil

                guard !trimmedQuery.isEmpty else {
                    state.isSearching = false
                    state.results = []
                    return .cancel(id: CancelID.search)
                }

                state.isSearching = true
                return .run { [trimmedQuery] send in
                    try await clock.sleep(for: .milliseconds(300))
                    await send(.searchResponse(TaskResult {
                        try await placesClient.search(trimmedQuery)
                    }))
                }
                .cancellable(id: CancelID.search, cancelInFlight: true)

            case .binding:
                return .none

            case .view(.cancelTapped):
                return .send(.delegate(.cancelled))

            case let .view(.placeTapped(place)):
                return .send(.delegate(.placeSelected(place)))

            case let .searchResponse(.success(results)):
                state.isSearching = false
                state.results = results
                return .none

            case .searchResponse(.failure):
                state.isSearching = false
                state.errorMessage = "Could not load places."
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
