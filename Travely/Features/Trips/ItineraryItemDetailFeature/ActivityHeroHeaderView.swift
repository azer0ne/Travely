import SwiftUI

struct ActivityHeroHeaderView: View {
    let category: ItineraryItemCategory?

    var body: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.90, green: 0.93, blue: 1.0),
                        Color(red: 0.96, green: 0.97, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(maxWidth: .infinity)
            .frame(height: 192)
            .overlay {
                Circle()
                    .fill(.white.opacity(0.75))
                    .frame(width: 108, height: 108)
                    .overlay {
                        Image(systemName: symbolName)
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                    }
            }
    }

    private var symbolName: String {
        switch category {
        case .transport:
            "tram.fill"
        case .hotel:
            "bed.double.fill"
        case .food:
            "fork.knife"
        case .activity:
            "figure.walk"
        case nil:
            "calendar"
        }
    }
}
