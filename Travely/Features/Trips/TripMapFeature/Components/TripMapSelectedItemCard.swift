import SwiftUI

struct TripMapSelectedItemCard: View {
    let item: ItineraryItem
    let onDismissTapped: () -> Void
    let onViewDetailTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.primary)

                    if let placeName = item.attachedPlace?.name {
                        Text(placeName)
                            .font(.subheadline)
                            .foregroundStyle(Color.appSecondary)
                    }
                }

                Spacer()

                Button("Close", systemImage: "xmark") {
                    onDismissTapped()
                }
                .labelStyle(.iconOnly)
                .foregroundStyle(Color.appSecondary)
            }

            HStack(spacing: 10) {
                Label {
                    Text(item.date.formatted(.dateTime.month(.abbreviated).day()))
                } icon: {
                    Image(systemName: "calendar")
                }

                Label {
                    Text(item.time.formatted(date: .omitted, time: .shortened))
                } icon: {
                    Image(systemName: "clock")
                }
            }
            .font(.caption)
            .foregroundStyle(Color.appSecondary)

            if let category = item.category {
                Text(category.title.uppercased())
                    .font(.caption)
                    .bold()
                    .foregroundStyle(Color.appPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.appPrimary.opacity(0.1))
                    .clipShape(.capsule)
            }

            Button("View Details", systemImage: "arrow.right.circle") {
                onViewDetailTapped()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.appPrimary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 24))
        .shadow(color: .black.opacity(0.12), radius: 18, y: 10)
    }
}
