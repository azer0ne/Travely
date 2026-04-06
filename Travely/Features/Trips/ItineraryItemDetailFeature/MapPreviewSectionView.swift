import MapKit
import SwiftUI

struct MapPreviewSectionView: View {
    let place: Place
    let onViewMapTapped: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(initialPosition: .region(region), interactionModes: []) {
                Marker(place.name, coordinate: coordinate)
            }
            .allowsHitTesting(false)
            .overlay {
                LinearGradient(
                    colors: [
                        .clear,
                        .black.opacity(0.06)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }

            Button("View Map", systemImage: "map") {
                onViewMapTapped()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.appPrimary)
            .padding(18)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .clipShape(.rect(cornerRadius: 24))
        .accessibilityLabel("Map preview for \(place.name)")
    }

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: place.latitude,
            longitude: place.longitude
        )
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}
