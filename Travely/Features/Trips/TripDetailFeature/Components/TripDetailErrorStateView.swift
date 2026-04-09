import SwiftUI

struct TripDetailErrorStateView: View {
    let errorMessage: String
    let onRetryTapped: () -> Void

    var body: some View {
        ContentUnavailableView(
            "Itinerary Unavailable",
            systemImage: "exclamationmark.triangle",
            description: Text(errorMessage)
        )
        .overlay(alignment: .bottom) {
            Button("Retry", systemImage: "arrow.clockwise", action: onRetryTapped)
                .buttonStyle(.borderedProminent)
                .padding()
        }
    }
}
