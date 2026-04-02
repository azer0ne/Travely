import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var explore = ExploreFeature.State()
        var map = MapFeature.State()
        var path = StackState<Path.State>()
        var search = SearchFeature.State()
        var selectedTab = Tab.explore
        var trips = TripListFeature.State()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case explore(ExploreFeature.Action)
        case map(MapFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case search(SearchFeature.Action)
        case trips(TripListFeature.Action)
    }

    enum Tab: String, CaseIterable, Equatable {
        case explore
        case search
        case trips
        case map
    }

    @Reducer
    enum Path {
        case itineraryItemDetail(ItineraryItemDetailFeature)
        case tripDetail(TripDetailFeature)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Scope(state: \.explore, action: \.explore) {
            ExploreFeature()
        }
        Scope(state: \.search, action: \.search) {
            SearchFeature()
        }
        Scope(state: \.trips, action: \.trips) {
            TripListFeature()
        }
        Scope(state: \.map, action: \.map) {
            MapFeature()
        }

        Reduce { state, action in
            switch action {
            case let .trips(.delegate(.tripSelected(trip))):
                state.path.append(.tripDetail(TripDetailFeature.State(trip: trip)))
                return .none

            case let .path(.element(id: _, action: .tripDetail(.delegate(.itineraryItemSelected(trip, item))))):
                state.path.append(.itineraryItemDetail(ItineraryItemDetailFeature.State(trip: trip, itineraryItem: item)))
                return .none

            case .path(.element(id: _, action: .tripDetail(.delegate(.viewMapRequested(_))))):
                return .none

            case let .path(.element(id: _, action: .itineraryItemDetail(.delegate(.itineraryItemUpdated(tripID, item))))):
                state.updateTripDetailState(for: tripID, itineraryItem: item)
                return .none

            case .binding:
                return .none

            case .explore:
                return .none

            case .map:
                return .none

            case .path:
                return .none

            case .search:
                return .none

            case .trips:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension AppFeature.Path.State: Equatable {}

private extension AppFeature.State {
    mutating func updateTripDetailState(for tripID: Trip.ID, itineraryItem: ItineraryItem) {
        for elementID in path.ids {
            guard var tripDetailState = path[id: elementID, case: \.tripDetail] else {
                continue
            }

            guard tripDetailState.trip.id == tripID else {
                continue
            }

            let updatedItems = tripDetailState.trip.itineraryItems.map { existingItem in
                existingItem.id == itineraryItem.id ? itineraryItem : existingItem
            }

            tripDetailState.trip.itineraryItems = updatedItems
            tripDetailState.updateItineraryItems(updatedItems)
            path[id: elementID, case: \.tripDetail] = tripDetailState
        }
    }
}
