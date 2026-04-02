import SwiftUI

struct MapPreviewSectionView: View {
    let place: Place
    let onOpenInMapsTapped: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapPreviewArtworkView()

            Button("Open in Maps", systemImage: "map") {
                onOpenInMapsTapped()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.11, green: 0.46, blue: 0.95))
            .padding(18)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .clipShape(.rect(cornerRadius: 24))
        .overlay(alignment: .topLeading) {
            Text(place.name)
                .font(.caption)
                .bold()
                .foregroundStyle(.clear)
                .padding(.top, 1)
                .accessibilityHidden(true)
        }
    }
}
