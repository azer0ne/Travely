import SwiftUI

struct PlacePickerResultRowView: View {
    let place: Place

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(place.name)
                    .foregroundStyle(.primary)
                    .font(.headline)

                if let category = place.category, !category.isEmpty {
                    Text(category)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }

            Text(place.address)
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
        .padding(.vertical, 6)
    }
}
