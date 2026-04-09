import Foundation

enum ItineraryItemCategory: String, CaseIterable, Equatable, Identifiable, Sendable {
    case transport
    case hotel
    case food
    case activity

    var id: String { rawValue }

    var title: String {
        switch self {
        case .transport:
            "Transport"
        case .hotel:
            "Hotel"
        case .food:
            "Food"
        case .activity:
            "Activity"
        }
    }
}
