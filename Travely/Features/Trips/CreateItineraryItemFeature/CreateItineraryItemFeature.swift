import ComposableArchitecture
import Foundation

@Reducer
struct CreateItineraryItemFeature {
    @Dependency(\.tripRepository) var tripRepository

    @ObservableState
    struct State: Equatable {
        enum Mode: Equatable {
            case create
            case edit(ItineraryItem.ID)
        }

        @Presents var placePicker: PlacePickerFeature.State?
        var attachedPlace: Place?
        var errorMessage: String?
        var isSaving = false
        var mode: Mode
        var notes = ""
        var selectedCategory: ItineraryItemCategory?
        var selectedDate: Date
        var selectedTime: Date
        var title = ""
        var trip: Trip

        init(trip: Trip) {
            self.mode = .create
            self.trip = trip
            self.selectedDate = trip.startDate ?? .now
            self.selectedTime = .now
        }

        init(trip: Trip, itineraryItem: ItineraryItem) {
            self.mode = .edit(itineraryItem.id)
            self.attachedPlace = itineraryItem.attachedPlace
            self.notes = itineraryItem.notes
            self.selectedCategory = itineraryItem.category
            self.selectedDate = itineraryItem.date
            self.selectedTime = itineraryItem.time
            self.title = itineraryItem.title
            self.trip = trip
        }

        var isSaveDisabled: Bool {
            isSaving || title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        var navigationTitle: String {
            switch mode {
            case .create:
                "Add to Trip"
            case .edit:
                "Edit Itinerary"
            }
        }

        var saveButtonTitle: String {
            switch mode {
            case .create:
                "Save to Itinerary"
            case .edit:
                "Save Changes"
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case delegate(DelegateAction)
        case placePicker(PresentationAction<PlacePickerFeature.Action>)
        case saveResponse(TaskResult<ItineraryItem>)
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case cancelled
        case itineraryItemCreated(ItineraryItem)
        case itineraryItemUpdated(ItineraryItem)
    }

    enum ViewAction: Equatable {
        case cancelTapped
        case categoryTapped(ItineraryItemCategory)
        case locationTapped
        case removeLocationTapped
        case saveTapped
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                state.errorMessage = nil
                return .none

            case .view(.cancelTapped):
                return .send(.delegate(.cancelled))

            case let .view(.categoryTapped(category)):
                state.selectedCategory = state.selectedCategory == category ? nil : category
                return .none

            case .view(.locationTapped):
                state.placePicker = PlacePickerFeature.State(query: state.attachedPlace?.name ?? "")
                return .none

            case .view(.removeLocationTapped):
                state.attachedPlace = nil
                return .none

            case .view(.saveTapped):
                let trimmedTitle = state.title.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedTitle.isEmpty else {
                    state.errorMessage = "Enter a title for this plan."
                    return .none
                }

                state.isSaving = true
                state.errorMessage = nil
                let itemID = state.itemID

                let item = ItineraryItem(
                    id: itemID,
                    title: trimmedTitle,
                    category: state.selectedCategory,
                    date: state.selectedDate,
                    time: state.selectedTime,
                    notes: state.notes.trimmingCharacters(in: .whitespacesAndNewlines),
                    attachedPlace: state.attachedPlace
                )

                return .run { [item, mode = state.mode, tripID = state.trip.id] send in
                    await send(.saveResponse(TaskResult {
                        switch mode {
                        case .create:
                            try await tripRepository.addItineraryItem(item, tripID)
                        case .edit:
                            try await tripRepository.updateItineraryItem(item, tripID)
                        }
                        return item
                    }))
                }

            case let .saveResponse(.success(item)):
                state.isSaving = false
                switch state.mode {
                case .create:
                    return .send(.delegate(.itineraryItemCreated(item)))
                case .edit:
                    return .send(.delegate(.itineraryItemUpdated(item)))
                }

            case .saveResponse(.failure):
                state.isSaving = false
                state.errorMessage = "Could not save this itinerary item."
                return .none

            case .placePicker(.presented(.delegate(.cancelled))):
                state.placePicker = nil
                return .none

            case let .placePicker(.presented(.delegate(.placeSelected(place)))):
                state.attachedPlace = place
                state.placePicker = nil
                return .none

            case .placePicker:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$placePicker, action: \.placePicker) {
            PlacePickerFeature()
        }
    }
}

private extension CreateItineraryItemFeature.State {
    var itemID: UUID {
        switch mode {
        case .create:
            UUID()
        case let .edit(itemID):
            itemID
        }
    }
}
