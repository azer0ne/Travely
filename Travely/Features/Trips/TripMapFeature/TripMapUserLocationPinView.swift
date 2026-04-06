import SwiftUI

struct TripMapUserLocationPinView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.appPrimary.opacity(0.18))
                .frame(width: 28, height: 28)

            Circle()
                .fill(Color.appPrimary)
                .frame(width: 14, height: 14)
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: 3)
                }
        }
        .accessibilityLabel("Your current location")
    }
}
