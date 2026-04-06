import ComposableArchitecture
import Foundation

@Reducer
struct TripMapFeature {
    @Dependency(\.locationClient) var locationClient
    @Dependency(\.tripRepository) var tripRepository

    @ObservableState
    struct State: Equatable {
        var errorMessage: String?
        var isLoading = false
        var itineraryItems: [ItineraryItem]
        var mapViewport: TripMapViewport
        var selectedItem: ItineraryItem?
        var trip: Trip
        var userLocation: TripMapViewport.Coordinate?

        init(trip: Trip) {
            self.trip = trip
            let items = Self.sortItineraryItems(trip.itineraryItems)
            self.itineraryItems = items
            self.mapViewport = Self.makeViewport(from: items)
        }

        var mappableItems: [ItineraryItem] {
            itineraryItems.filter { $0.attachedPlace != nil }
        }

        var showsEmptyState: Bool {
            !isLoading && errorMessage == nil && mappableItems.isEmpty
        }

        mutating func updateItineraryItems(_ items: [ItineraryItem]) {
            let sortedItems = Self.sortItineraryItems(items)
            itineraryItems = sortedItems
            trip.itineraryItems = sortedItems
            mapViewport = Self.makeViewport(from: sortedItems)

            if let selectedItem {
                self.selectedItem = sortedItems.first(where: { $0.id == selectedItem.id && $0.attachedPlace != nil })
            }
        }

        mutating func updateSelectedItem(_ item: ItineraryItem) {
            selectedItem = itineraryItems.first(where: { $0.id == item.id }) ?? item
        }

        static func sortItineraryItems(_ items: [ItineraryItem]) -> [ItineraryItem] {
            items.sorted { lhs, rhs in
                if lhs.date != rhs.date {
                    return lhs.date < rhs.date
                }

                return lhs.time < rhs.time
            }
        }

        static func makeViewport(from items: [ItineraryItem]) -> TripMapViewport {
            let coordinates = items.compactMap(\.attachedPlace).map {
                TripMapViewport.Coordinate(latitude: $0.latitude, longitude: $0.longitude)
            }

            return TripMapViewport.fitting(coordinates)
        }
    }

    enum Action {
        case delegate(DelegateAction)
        case itineraryItemsResponse(TaskResult<[ItineraryItem]>)
        case pinTapped(ItineraryItem)
        case selectedItemCleared
        case userLocationResponse(TaskResult<TripMapViewport.Coordinate?>)
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case itineraryItemSelected(Trip, ItineraryItem)
    }

    enum ViewAction: Equatable {
        case itemDetailTapped
        case markerTapped(ItineraryItem.ID)
        case onAppear
    }

    private enum CancelID {
        case loadItinerary
        case loadUserLocation
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state.isLoading = true
                state.errorMessage = nil

                let tripID = state.trip.id
                return .merge(
                    .run { send in
                        await send(
                            .itineraryItemsResponse(
                                TaskResult {
                                    try await tripRepository.fetchItineraryItems(tripID)
                                }
                            )
                        )
                    }
                    .cancellable(id: CancelID.loadItinerary, cancelInFlight: true),
                    .run { send in
                        await send(
                            .userLocationResponse(
                                TaskResult {
                                    try await locationClient.currentCoordinates().map {
                                        TripMapViewport.Coordinate(
                                            latitude: $0.latitude,
                                            longitude: $0.longitude
                                        )
                                    }
                                }
                            )
                        )
                    }
                    .cancellable(id: CancelID.loadUserLocation, cancelInFlight: true)
                )

            case let .itineraryItemsResponse(.success(items)):
                state.isLoading = false
                state.errorMessage = nil
                state.updateItineraryItems(items)
                return .none

            case .itineraryItemsResponse(.failure):
                state.isLoading = false
                state.errorMessage = "Could not load trip map."
                return .none

            case let .userLocationResponse(.success(coordinate)):
                state.userLocation = coordinate
                return .none

            case .userLocationResponse(.failure):
                state.userLocation = nil
                return .none

            case let .view(.markerTapped(itemID)):
                guard let item = state.mappableItems.first(where: { $0.id == itemID }) else {
                    return .send(.selectedItemCleared)
                }

                return .send(.pinTapped(item))

            case let .pinTapped(item):
                state.updateSelectedItem(item)
                return .none

            case .selectedItemCleared:
                state.selectedItem = nil
                return .none

            case .view(.itemDetailTapped):
                guard let selectedItem = state.selectedItem else {
                    return .none
                }

                return .send(.delegate(.itineraryItemSelected(state.trip, selectedItem)))

            case .delegate:
                return .none
            }
        }
    }
}
