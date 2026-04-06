import SwiftUI

struct ItineraryItemHeaderView: View {
    let itineraryItem: ItineraryItem

    var body: some View {
        ActivityHeroHeaderView(category: itineraryItem.category)
    }
}
