import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var trips = TripListFeature.State()
    }

    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case trips(TripListFeature.Action)
    }

    @Reducer
    enum Path {
        case itineraryItemDetail(ItineraryItemDetailFeature)
        case tripDetail(TripDetailFeature)
        case tripMap(TripMapFeature)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.trips, action: \.trips) {
            TripListFeature()
        }

        Reduce { state, action in
            switch action {
            case let .trips(.delegate(.tripSelected(trip))):
                state.path.append(.tripDetail(TripDetailFeature.State(trip: trip)))
                return .none

            case let .path(.element(id: _, action: .tripDetail(.delegate(.itineraryItemSelected(trip, item))))):
                state.path.append(.itineraryItemDetail(ItineraryItemDetailFeature.State(trip: trip, itineraryItem: item)))
                return .none

            case let .path(.element(id: _, action: .tripDetail(.delegate(.viewMapRequested(trip))))):
                state.path.append(.tripMap(TripMapFeature.State(trip: trip)))
                return .none

            case let .path(.element(id: _, action: .tripMap(.delegate(.itineraryItemSelected(trip, item))))):
                state.path.append(.itineraryItemDetail(ItineraryItemDetailFeature.State(trip: trip, itineraryItem: item)))
                return .none

            case let .path(.element(id: _, action: .tripDetail(.delegate(.tripUpdated(trip))))):
                state.syncTrip(trip)
                return .none

            case let .path(.element(id: _, action: .itineraryItemDetail(.delegate(.tripUpdated(trip))))):
                state.syncTrip(trip)
                return .none

            case .path:
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
    mutating func syncTrip(_ trip: Trip) {
        if let tripIndex = trips.trips.firstIndex(where: { $0.id == trip.id }) {
            trips.trips[tripIndex] = trip
        } else {
            trips.trips.append(trip)
        }
        trips.trips.sort { lhs, rhs in
            lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
        }

        for elementID in path.ids {
            if var tripDetailState = path[id: elementID, case: \.tripDetail] {
                guard tripDetailState.trip.id == trip.id else {
                    continue
                }

                tripDetailState.trip = trip
                tripDetailState.updateItineraryItems(trip.itineraryItems)
                path[id: elementID, case: \.tripDetail] = tripDetailState
            }

            if var tripMapState = path[id: elementID, case: \.tripMap] {
                guard tripMapState.trip.id == trip.id else {
                    continue
                }

                tripMapState.trip = trip
                tripMapState.updateItineraryItems(trip.itineraryItems)
                path[id: elementID, case: \.tripMap] = tripMapState
            }

            if var itineraryItemDetailState = path[id: elementID, case: \.itineraryItemDetail] {
                guard itineraryItemDetailState.trip.id == trip.id else {
                    continue
                }

                itineraryItemDetailState.trip = trip
                if let updatedItem = trip.itineraryItems.first(where: { $0.id == itineraryItemDetailState.itineraryItem.id }) {
                    itineraryItemDetailState.itineraryItem = updatedItem
                }
                path[id: elementID, case: \.itineraryItemDetail] = itineraryItemDetailState
            }
        }
    }
}
