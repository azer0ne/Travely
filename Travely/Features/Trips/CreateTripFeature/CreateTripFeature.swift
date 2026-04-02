import ComposableArchitecture
import Foundation
import PhotosUI
import SwiftUI

@Reducer
struct CreateTripFeature {
    @Dependency(\.tripRepository) var tripRepository

    @ObservableState
    struct State: Equatable {
        var name = ""
        var selectedImageData: Data?
        var includesStartDate = false
        var startDate = Date.now
        var includesEndDate = false
        var endDate = Date.now
        var isSaving = false
        var validationMessage: String?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case delegate(DelegateAction)
        case selectedImageDataResponse(TaskResult<Data?>)
        case saveResponse(TaskResult<Trip>)
        case view(ViewAction)
    }

    enum DelegateAction: Equatable {
        case cancelled
        case tripCreated(Trip)
    }

    enum ViewAction {
        case cancelTapped
        case photoPickerItemChanged(PhotosPickerItem?)
        case saveTapped
        case removePhotoTapped
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                state.validationMessage = nil
                return .none

            case .view(.cancelTapped):
                return .send(.delegate(.cancelled))

            case let .view(.photoPickerItemChanged(item)):
                guard let item else {
                    return .none
                }

                return .run { send in
                    await send(.selectedImageDataResponse(TaskResult {
                        try await item.loadTransferable(type: Data.self)
                    }))
                }

            case .view(.removePhotoTapped):
                state.selectedImageData = nil
                return .none

            case .view(.saveTapped):
                let trimmedName = state.name.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !trimmedName.isEmpty else {
                    state.validationMessage = "Enter a trip name."
                    return .none
                }

                state.isSaving = true
                state.validationMessage = nil

                let trip = Trip(
                    imageData: state.selectedImageData,
                    name: trimmedName,
                    startDate: state.includesStartDate ? state.startDate : nil,
                    endDate: state.includesEndDate ? state.endDate : nil
                )

                return .run { [trip] send in
                    await send(.saveResponse(TaskResult {
                        try await tripRepository.createTrip(trip)
                        return trip
                    }))
                }

            case let .saveResponse(.success(trip)):
                state.isSaving = false
                return .send(.delegate(.tripCreated(trip)))

            case let .selectedImageDataResponse(.success(data)):
                state.selectedImageData = data
                return .none

            case .selectedImageDataResponse(.failure):
                state.validationMessage = "Could not load photo."
                return .none

            case .saveResponse(.failure):
                state.isSaving = false
                state.validationMessage = "Could not save trip."
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
