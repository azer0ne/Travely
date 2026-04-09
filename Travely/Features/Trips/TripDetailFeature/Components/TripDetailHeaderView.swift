import SwiftUI

struct TripDetailHeaderView: View {
    let trip: Trip

    var body: some View {
        TripHeroCardView(trip: trip)
    }
}
