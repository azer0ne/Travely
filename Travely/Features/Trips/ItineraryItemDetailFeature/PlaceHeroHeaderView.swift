import SwiftUI
import UIKit

struct PlaceHeroHeaderView: View {
    let category: ItineraryItemCategory?
    let title: String
    let tripImageData: Data?

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let heroImage {
                Image(uiImage: heroImage)
                    .resizable()
                    .scaledToFill()
            } else {
                PlaceHeroPlaceholderView()
            }

            if let category {
                ItineraryCategoryBadgeView(category: category)
                    .padding(14)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 244)
        .clipShape(.rect(cornerRadius: 28))
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
        .accessibilityLabel(title)
    }

    private var heroImage: UIImage? {
        guard let tripImageData else { return nil }
        return UIImage(data: tripImageData)
    }
}
