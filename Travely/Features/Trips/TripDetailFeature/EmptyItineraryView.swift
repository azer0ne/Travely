import SwiftUI

struct EmptyItineraryView: View {
    var body: some View {
        ContentUnavailableView {
            Label("No plans yet", systemImage: "calendar.badge.plus")
        } description: {
            Text("Start building this trip by adding places to your itinerary.")
        }
    }
}
