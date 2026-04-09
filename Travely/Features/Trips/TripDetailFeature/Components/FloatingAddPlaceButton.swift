import SwiftUI

struct FloatingAddPlaceButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Add Place", systemImage: "plus")
                .labelStyle(.iconOnly)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 58, height: 58)
                .background(
                    Circle()
                        .fill(Color.appPrimary)
                )
        }
        .shadow(color: .black.opacity(0.18), radius: 16, y: 10)
    }
}
