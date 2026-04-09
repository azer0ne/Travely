import SwiftUI

struct ItineraryRowView: View {
    let item: ItineraryItem
    let onDeleteTapped: () -> Void
    let onTapped: () -> Void

    var body: some View {
        Button(action: onTapped) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconBackgroundColor)
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: symbolName)
                            .foregroundStyle(Color.appPrimary)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.time.formatted(date: .omitted, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)

                    if let attachedPlace = item.attachedPlace {
                        Text(attachedPlace.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(.white)
            .clipShape(.rect(cornerRadius: 18))
            .shadow(color: .black.opacity(0.04), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
        .swipeActions {
            Button("Delete", role: .destructive, action: onDeleteTapped)
        }
    }

    private var symbolName: String {
        if let category = item.category {
            switch category {
            case .transport:
                return "airplane"
            case .hotel:
                return "bed.double.fill"
            case .food:
                return "fork.knife"
            case .activity:
                return "figure.walk"
            }
        }

        let attachedPlaceDescription = item.attachedPlace?.category ?? item.attachedPlace?.name ?? item.title

        if attachedPlaceDescription.localizedStandardContains("airport") || attachedPlaceDescription.localizedStandardContains("flight") {
            return "airplane"
        } else if attachedPlaceDescription.localizedStandardContains("hotel") {
            return "bed.double.fill"
        } else if attachedPlaceDescription.localizedStandardContains("restaurant") || attachedPlaceDescription.localizedStandardContains("food") {
            return "fork.knife"
        } else if attachedPlaceDescription.localizedStandardContains("museum") {
            return "building.columns.fill"
        } else if attachedPlaceDescription.localizedStandardContains("park") || attachedPlaceDescription.localizedStandardContains("garden") {
            return "tree.fill"
        } else {
            return "mappin.and.ellipse"
        }
    }

    private var iconBackgroundColor: Color {
        Color.appNeutral
    }
}
