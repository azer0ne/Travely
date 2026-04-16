import ComposableArchitecture
import Foundation

@Reducer
struct ItineraryItemDetailFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var editItineraryItem: CreateItineraryItemFeature.State?
        @Presents var placeMap: PlaceMapFeature.State?
        var itineraryItem: ItineraryItem
        var trip: Trip

        init(trip: Trip, itineraryItem: ItineraryItem) {
            self.itineraryItem = itineraryItem
            self.trip = trip
        }

        var hasAttachedPlace: Bool {
            itineraryItem.attachedPlace != nil
        }

        var hasHeroImage: Bool {
            trip.imageData != nil
        }

        var hasNotes: Bool {
            !itineraryItem.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    enum Action {
        case delegate(DelegateAction)
        case editItineraryItem(PresentationAction<CreateItineraryItemFeature.Action>)
        case placeMap(PresentationAction<PlaceMapFeature.Action>)
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case tripUpdated(Trip)
    }

    enum ViewAction: Equatable {
        case editTapped
        case onAppear
        case viewMapTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .view(.editTapped):
                state.editItineraryItem = CreateItineraryItemFeature.State(
                    trip: state.trip,
                    itineraryItem: state.itineraryItem
                )
                return .none

            case .view(.viewMapTapped):
                guard let attachedPlace = state.itineraryItem.attachedPlace else {
                    return .none
                }

                state.placeMap = PlaceMapFeature.State(place: attachedPlace)
                return .none

            case .editItineraryItem(.presented(.delegate(.cancelled))):
                state.editItineraryItem = nil
                return .none

            case let .editItineraryItem(.presented(.delegate(.itineraryItemUpdated(item)))):
                state.editItineraryItem = nil
                state.itineraryItem = item
                state.trip.itineraryItems = state.trip.itineraryItems.map { existingItem in
                    existingItem.id == item.id ? item : existingItem
                }
                return .send(.delegate(.tripUpdated(state.trip)))

            case .editItineraryItem(.presented(.delegate(.itineraryItemCreated))):
                return .none

            case .placeMap:
                return .none

            case .delegate:
                return .none

            case .editItineraryItem:
                return .none
            }
        }
        .ifLet(\.$editItineraryItem, action: \.editItineraryItem) {
            CreateItineraryItemFeature()
        }
        .ifLet(\.$placeMap, action: \.placeMap) {
            PlaceMapFeature()
        }
    }
}
