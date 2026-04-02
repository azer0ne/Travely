import ComposableArchitecture
import Foundation

@Reducer
struct ItineraryItemDetailFeature {
    @Dependency(\.externalMapsClient) var externalMapsClient

    @ObservableState
    struct State: Equatable {
        @Presents var editItineraryItem: CreateItineraryItemFeature.State?
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

        var mapURL: URL? {
            guard let attachedPlace = itineraryItem.attachedPlace else {
                return nil
            }

            var components = URLComponents(string: "https://maps.apple.com")
            components?.queryItems = [
                URLQueryItem(name: "ll", value: "\(attachedPlace.latitude),\(attachedPlace.longitude)"),
                URLQueryItem(name: "q", value: attachedPlace.name)
            ]
            return components?.url
        }
    }

    enum Action {
        case delegate(DelegateAction)
        case editItineraryItem(PresentationAction<CreateItineraryItemFeature.Action>)
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case itineraryItemUpdated(Trip.ID, ItineraryItem)
    }

    enum ViewAction: Equatable {
        case editTapped
        case onAppear
        case openInMapsTapped
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

            case .view(.openInMapsTapped):
                guard let mapURL = state.mapURL else {
                    return .none
                }

                return .run { _ in
                    await externalMapsClient.open(mapURL)
                }

            case .editItineraryItem(.presented(.delegate(.cancelled))):
                state.editItineraryItem = nil
                return .none

            case let .editItineraryItem(.presented(.delegate(.itineraryItemUpdated(item)))):
                state.editItineraryItem = nil
                state.itineraryItem = item
                state.trip.itineraryItems = state.trip.itineraryItems.map { existingItem in
                    existingItem.id == item.id ? item : existingItem
                }
                return .send(.delegate(.itineraryItemUpdated(state.trip.id, item)))

            case .editItineraryItem(.presented(.delegate(.itineraryItemCreated))):
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
    }
}
