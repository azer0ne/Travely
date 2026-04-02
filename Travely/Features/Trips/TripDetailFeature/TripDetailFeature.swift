import ComposableArchitecture
import Foundation

@Reducer
struct TripDetailFeature {
    @Dependency(\.tripRepository) var tripRepository

    @ObservableState
    struct State: Equatable {
        @Presents var createItineraryItem: CreateItineraryItemFeature.State?

        struct ItinerarySection: Equatable, Identifiable {
            let date: Date
            let items: [ItineraryItem]

            var id: Date {
                Calendar.autoupdatingCurrent.startOfDay(for: date)
            }
        }

        var errorMessage: String?
        var isLoading = false
        var itineraryItems: [ItineraryItem]
        var itinerarySections: [ItinerarySection]
        var trip: Trip

        init(trip: Trip) {
            self.trip = trip

            let sortedItems = Self.sortItineraryItems(trip.itineraryItems)
            self.itineraryItems = sortedItems
            self.itinerarySections = Self.makeItinerarySections(from: sortedItems)
        }

        var isEmpty: Bool {
            !isLoading && errorMessage == nil && itineraryItems.isEmpty
        }

        mutating func updateItineraryItems(_ items: [ItineraryItem]) {
            let sortedItems = Self.sortItineraryItems(items)
            itineraryItems = sortedItems
            itinerarySections = Self.makeItinerarySections(from: sortedItems)
            trip.itineraryItems = sortedItems
        }

        static func makeItinerarySections(from items: [ItineraryItem]) -> [ItinerarySection] {
            let groupedItems = Dictionary(grouping: items) { item in
                Calendar.autoupdatingCurrent.startOfDay(for: item.date)
            }

            return groupedItems
                .map { date, groupedItems in
                    ItinerarySection(
                        date: date,
                        items: groupedItems.sorted { lhs, rhs in
                            lhs.time < rhs.time
                        }
                    )
                }
                .sorted { lhs, rhs in
                    lhs.date < rhs.date
                }
        }

        static func sortItineraryItems(_ items: [ItineraryItem]) -> [ItineraryItem] {
            items.sorted { lhs, rhs in
                if lhs.date != rhs.date {
                    return lhs.date < rhs.date
                }

                return lhs.time < rhs.time
            }
        }
    }

    enum Action {
        case createItineraryItem(PresentationAction<CreateItineraryItemFeature.Action>)
        case delegate(DelegateAction)
        case itineraryItemsLoadFailed
        case itineraryItemsLoaded([ItineraryItem])
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case itineraryItemSelected(Trip, ItineraryItem)
        case viewMapRequested(Trip)
    }

    enum ViewAction {
        case addPlaceTapped
        case deleteItineraryItemTapped(ItineraryItem.ID)
        case itineraryItemTapped(ItineraryItem.ID)
        case onAppear
        case viewMapTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state.isLoading = true
                state.errorMessage = nil

                let tripID = state.trip.id
                return .run { send in
                    do {
                        let items = try await tripRepository.fetchItineraryItems(tripID)
                        await send(.itineraryItemsLoaded(items))
                    } catch {
                        await send(.itineraryItemsLoadFailed)
                    }
                }

            case .view(.addPlaceTapped):
                state.createItineraryItem = CreateItineraryItemFeature.State(trip: state.trip)
                return .none

            case .view(.viewMapTapped):
                return .send(.delegate(.viewMapRequested(state.trip)))

            case let .view(.itineraryItemTapped(itemID)):
                guard let item = state.itineraryItems.first(where: { $0.id == itemID }) else {
                    return .none
                }

                return .send(.delegate(.itineraryItemSelected(state.trip, item)))

            case let .view(.deleteItineraryItemTapped(itemID)):
                state.isLoading = true
                state.errorMessage = nil

                let tripID = state.trip.id
                return .run { send in
                    do {
                        try await tripRepository.deleteItineraryItem(itemID, tripID)
                        let items = try await tripRepository.fetchItineraryItems(tripID)
                        await send(.itineraryItemsLoaded(items))
                    } catch {
                        await send(.itineraryItemsLoadFailed)
                    }
                }

            case let .itineraryItemsLoaded(items):
                state.isLoading = false
                state.errorMessage = nil
                state.updateItineraryItems(items)
                return .none

            case .itineraryItemsLoadFailed:
                state.isLoading = false
                state.errorMessage = "Could not load itinerary."
                return .none

            case .createItineraryItem(.presented(.delegate(.cancelled))):
                state.createItineraryItem = nil
                return .none

            case .createItineraryItem(.presented(.delegate(.itineraryItemCreated))):
                state.createItineraryItem = nil
                state.isLoading = true
                state.errorMessage = nil

                let tripID = state.trip.id
                return .run { send in
                    do {
                        let items = try await tripRepository.fetchItineraryItems(tripID)
                        await send(.itineraryItemsLoaded(items))
                    } catch {
                        await send(.itineraryItemsLoadFailed)
                    }
                }

            case let .createItineraryItem(.presented(.delegate(.itineraryItemUpdated(item)))):
                state.createItineraryItem = nil
                state.trip.itineraryItems = state.trip.itineraryItems.map { existingItem in
                    existingItem.id == item.id ? item : existingItem
                }
                state.updateItineraryItems(state.trip.itineraryItems)
                return .none

            case .createItineraryItem:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$createItineraryItem, action: \.createItineraryItem) {
            CreateItineraryItemFeature()
        }
    }
}
