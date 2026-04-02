import SwiftUI
import UIKit

struct TripHeroCardView: View {
    let trip: Trip

    var body: some View {
        Group {
            if let heroImage = heroImage {
                Image(uiImage: heroImage)
                    .resizable()
                    .scaledToFill()
            } else {
                TripHeroPlaceholderArtworkView()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 190)
        .clipped()
        .overlay(alignment: .bottomLeading) {
            HStack(spacing: 0) {
                TripDateBadgeView(trip: trip)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .clipShape(.rect(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
    }

    private var heroImage: UIImage? {
        guard let imageData = trip.imageData else { return nil }
        return UIImage(data: imageData)
    }
}
