import ComposableArchitecture
import MapKit
import SwiftUI

struct PlaceMapView: View {
    let store: StoreOf<PlaceMapFeature>

    var body: some View {
        Map(initialPosition: .region(region)) {
            Marker(store.place.name, coordinate: coordinate)
        }
        .navigationTitle(store.place.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button("Open in Maps", systemImage: "map") {
                openInMaps()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(.ultraThinMaterial)
        }
    }

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: store.place.latitude,
            longitude: store.place.longitude
        )
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    private func openInMaps() {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = store.place.name
        mapItem.openInMaps()
    }
}

#Preview {
    NavigationStack {
        PlaceMapView(
            store: Store(
                initialState: PlaceMapFeature.State(
                    place: Place(
                        name: "Louvre Museum",
                        latitude: 48.8606,
                        longitude: 2.3376,
                        address: "Rue de Rivoli, 75001 Paris, France",
                        category: "Museum"
                    )
                )
            ) {
                PlaceMapFeature()
            }
        )
    }
}
