import SwiftUI

struct FloatingCreateTripButton: View {
    let action: () -> Void

    var body: some View {
        Button("Create Trip", systemImage: "plus", action: action)
            .labelStyle(.iconOnly)
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: 58, height: 58)
            .background(Color.appPrimary)
            .clipShape(.circle)
            .shadow(color: .blue.opacity(0.28), radius: 18, y: 10)
            .accessibilityLabel("Create Trip")
    }
}
