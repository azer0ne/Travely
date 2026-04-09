import SwiftUI

struct TripListHeaderView: View {
    let tripCount: Int
    let isLoading: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(.orange)
                            .frame(width: 34, height: 34)

                        Image(systemName: "person.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }

                    Text("Travely")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.primary)
                }

                Spacer()

                Button("Settings", systemImage: "gearshape") {}
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.secondary)
                    .buttonStyle(.plain)
                    .accessibilityLabel("Settings")
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("My Trips")
                    .font(.largeTitle)
                    .bold()

                Text(summaryText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var summaryText: String {
        if isLoading {
            "Loading your journeys"
        } else if tripCount == 0 {
            "No journeys planned yet"
        } else if tripCount == 1 {
            "1 journey planned"
        } else {
            "\(tripCount) journeys planned"
        }
    }
}
