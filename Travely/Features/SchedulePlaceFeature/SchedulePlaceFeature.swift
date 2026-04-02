import ComposableArchitecture
import Foundation

@Reducer
struct SchedulePlaceFeature {
    @ObservableState
    struct State: Equatable {
        var selectedDate = Date.now
        var selectedTime = Date.now
    }

    enum Action {
        case view(ViewAction)
    }

    enum ViewAction {
        case saveTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.saveTapped):
                return .none
            }
        }
    }
}
