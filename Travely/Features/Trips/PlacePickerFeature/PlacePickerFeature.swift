import ComposableArchitecture
import Foundation

@Reducer
struct PlacePickerFeature {
    @Dependency(\.continuousClock) var clock
    @Dependency(\.placesClient) var placesClient

    private enum CancelID {
        case search
    }

    @ObservableState
    struct State: Equatable {
        var errorMessage: String?
        var hasSearched = false
        var isLoading = false
        var query: String
        var results: [Place] = []

        init(query: String = "") {
            self.query = query
        }

        var showsInitialState: Bool {
            !isLoading
                && errorMessage == nil
                && results.isEmpty
                && !hasSearched
                && query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        var showsNoResults: Bool {
            hasSearched
                && !isLoading
                && errorMessage == nil
                && results.isEmpty
        }
    }

    enum Action {
        case delegate(DelegateAction)
        case resultsResponse(TaskResult<[Place]>)
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case cancelled
        case placeSelected(Place)
    }

    enum ViewAction: Equatable {
        case cancelTapped
        case placeTapped(Place)
        case queryChanged(String)
        case searchSubmitted
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.cancelTapped):
                return .send(.delegate(.cancelled))

            case let .view(.placeTapped(place)):
                return .send(.delegate(.placeSelected(place)))

            case let .view(.queryChanged(query)):
                state.query = query
                state.errorMessage = nil

                let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedQuery.isEmpty else {
                    state.hasSearched = false
                    state.isLoading = false
                    state.results = []
                    return .cancel(id: CancelID.search)
                }

                state.isLoading = true
                return searchEffect(for: trimmedQuery, debounce: true)

            case .view(.searchSubmitted):
                let trimmedQuery = state.query.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedQuery.isEmpty else {
                    state.hasSearched = false
                    state.isLoading = false
                    state.results = []
                    state.errorMessage = nil
                    return .cancel(id: CancelID.search)
                }

                state.isLoading = true
                state.errorMessage = nil
                return searchEffect(for: trimmedQuery, debounce: false)

            case let .resultsResponse(.success(results)):
                state.errorMessage = nil
                state.hasSearched = true
                state.isLoading = false
                state.results = results
                return .none

            case .resultsResponse(.failure(let error)) where error is CancellationError:
                return .none

            case .resultsResponse(.failure):
                state.errorMessage = "Could not load places."
                state.hasSearched = true
                state.isLoading = false
                state.results = []
                return .none

            case .delegate:
                return .none
            }
        }
    }

    private func searchEffect(
        for query: String,
        debounce: Bool
    ) -> Effect<Action> {
        .run { [clock, placesClient] send in
            if debounce {
                try await clock.sleep(for: .milliseconds(300))
            }

            try Task.checkCancellation()

            await send(.resultsResponse(TaskResult {
                try await placesClient.search(query)
            }))
        }
        .cancellable(id: CancelID.search, cancelInFlight: true)
    }
}
