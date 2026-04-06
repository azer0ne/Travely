import SwiftUI

struct DetailMetaSectionView: View {
    let itineraryItem: ItineraryItem

    var body: some View {
        HStack(spacing: 14) {
            DetailMetaColumnView(
                label: "Date",
                systemImage: "calendar",
                value: itineraryItem.date.formatted(.dateTime.month(.abbreviated).day().year())
            )

            Divider()
                .frame(width: 1, height: 44)
                .padding(.vertical, 6)

            DetailMetaColumnView(
                label: "Time",
                systemImage: "clock",
                value: itineraryItem.time.formatted(date: .omitted, time: .shortened)
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(.rect(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
    }
}
