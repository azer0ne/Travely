import SwiftUI

struct DetailMetaSectionView: View {
    let itineraryItem: ItineraryItem

    var body: some View {
        HStack(spacing: 0) {
            DetailMetaColumnView(
                label: "Date",
                systemImage: "calendar",
                value: itineraryItem.date.formatted(.dateTime.month(.abbreviated).day().year())
            )

            Divider()
                .padding(.vertical, 18)

            DetailMetaColumnView(
                label: "Time",
                systemImage: "clock",
                value: itineraryItem.time.formatted(date: .omitted, time: .shortened)
            )
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(.rect(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
    }
}
