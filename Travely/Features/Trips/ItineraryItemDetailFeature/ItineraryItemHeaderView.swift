import SwiftUI

struct ItineraryItemHeaderView: View {
    let itineraryItem: ItineraryItem
    let tripImageData: Data?

    var body: some View {
        if itineraryItem.attachedPlace != nil {
            PlaceHeroHeaderView(
                category: itineraryItem.category,
                title: itineraryItem.title,
                tripImageData: tripImageData
            )
        } else {
            ActivityHeroHeaderView(category: itineraryItem.category)
        }
    }
}
