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
                        .fill(Color(red: 0.11, green: 0.46, blue: 0.95))
                )
        }
        .shadow(color: .black.opacity(0.18), radius: 16, y: 10)
    }
}
