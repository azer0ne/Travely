import SwiftUI

struct CreateItineraryItemHeaderView: View {
    @Binding var title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What are you planning?")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.primary)

            Text("Add a title for this itinerary item. For example: hotel check-in, airport transfer, or morning walk.")
                .foregroundStyle(.secondary)

            TextField("Itinerary title", text: $title, axis: .vertical)
                .textInputAutocapitalization(.sentences)
                .padding(18)
                .background(.white)
                .clipShape(.rect(cornerRadius: 20))
        }
    }
}
