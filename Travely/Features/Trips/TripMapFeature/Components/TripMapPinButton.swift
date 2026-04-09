import SwiftUI

struct TripMapPinButton: View {
    let item: ItineraryItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: symbolName)
                    .font(.body)
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(isSelected ? Color.appTertiary : Color.appPrimary)
                    .clipShape(.circle)
                    .shadow(color: .black.opacity(0.18), radius: 8, y: 4)

                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .foregroundStyle(isSelected ? Color.appTertiary : Color.appPrimary)
                    .offset(y: -4)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.title)
    }

    private var symbolName: String {
        if let placeSymbolName {
            return placeSymbolName
        }

        return switch item.category {
        case .transport:
            "tram.fill"
        case .hotel:
            "bed.double.fill"
        case .food:
            "fork.knife"
        case .activity:
            "figure.walk"
        case nil:
            "mappin"
        }
    }

    private var placeSymbolName: String? {
        guard let category = item.attachedPlace?.category?.trimmingCharacters(in: .whitespacesAndNewlines),
              !category.isEmpty else {
            return nil
        }

        let normalizedCategory = category.lowercased()

        if normalizedCategory.contains("airport") {
            return "airplane.departure"
        }

        if normalizedCategory.contains("hotel") {
            return "bed.double.fill"
        }

        if normalizedCategory.contains("restaurant") || normalizedCategory.contains("food") {
            return "fork.knife"
        }

        if normalizedCategory.contains("cafe") || normalizedCategory.contains("coffee") {
            return "cup.and.saucer.fill"
        }

        if normalizedCategory.contains("museum") {
            return "building.columns.fill"
        }

        if normalizedCategory.contains("park") || normalizedCategory.contains("garden") {
            return "tree.fill"
        }

        return nil
    }
}
