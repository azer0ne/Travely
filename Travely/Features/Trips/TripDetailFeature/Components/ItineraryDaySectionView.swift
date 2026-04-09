import SwiftUI

struct ItineraryDaySectionView: View {
    let dayNumber: Int
    let section: TripDetailFeature.State.ItinerarySection
    let onDeleteTapped: (ItineraryItem.ID) -> Void
    let onItemTapped: (ItineraryItem.ID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Day \(dayNumber)")
                .font(.title3)
                .bold()
                .foregroundStyle(.primary)

            VStack(spacing: 12) {
                ForEach(section.items) { item in
                    ItineraryRowView(
                        item: item,
                        onDeleteTapped: {
                            onDeleteTapped(item.id)
                        },
                        onTapped: {
                            onItemTapped(item.id)
                        }
                    )
                }
            }
        }
    }
}
