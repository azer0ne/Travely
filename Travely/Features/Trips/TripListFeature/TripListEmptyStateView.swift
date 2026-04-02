import SwiftUI

struct TripListEmptyStateView: View {
    let isLoading: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.45, green: 0.83, blue: 0.9),
                                Color(red: 0.18, green: 0.55, blue: 0.72)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)

                Image(systemName: isLoading ? "clock" : "suitcase.rolling")
                    .font(.system(size: 42))
                    .foregroundStyle(.white.opacity(0.95))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(isLoading ? "Loading your trips" : "Start your first trip")
                    .font(.title3)
                    .bold()

                Text(
                    isLoading
                    ? "We are checking your saved journeys."
                    : "Create a trip to organize places, dates, and your day-by-day plan."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(.white)
        .clipShape(.rect(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 16, y: 8)
    }
}

struct TripListInlineMessageView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundStyle(.red)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.red.opacity(0.08))
            .clipShape(.rect(cornerRadius: 14))
    }
}
