import ComposableArchitecture
import MapKit
import SwiftUI

struct TripMapView: View {
    @Bindable var store: StoreOf<TripMapFeature>

    var body: some View {
        Group {
            if store.isLoading && store.mappableItems.isEmpty {
                ProgressView("Loading Map")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appNeutral)
            } else if let errorMessage = store.errorMessage, store.mappableItems.isEmpty {
                ContentUnavailableView(
                    "Trip Map Unavailable",
                    systemImage: "exclamationmark.triangle",
                    description: Text(errorMessage)
                )
                .background(Color.appNeutral)
            } else if store.showsEmptyState {
                TripMapEmptyStateView()
            } else {
                mapContent
            }
        }
        .navigationTitle(store.trip.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.view(.onAppear))
        }
        .safeAreaInset(edge: .bottom) {
            if let selectedItem = store.selectedItem {
                TripMapSelectedItemCard(
                    item: selectedItem,
                    onDismissTapped: {
                        store.send(.selectedItemCleared)
                    },
                    onViewDetailTapped: {
                        store.send(.view(.itemDetailTapped))
                    }
                )
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
            }
        }
    }

    private var mapContent: some View {
        Map(initialPosition: .region(store.mapViewport.region)) {
            if let userLocation = store.userLocation {
                Annotation("Current Location", coordinate: userLocation.coordinate) {
                    TripMapUserLocationPinView()
                }
            }

            ForEach(store.mappableItems) { item in
                if let place = item.attachedPlace {
                    Annotation(item.title, coordinate: place.coordinate) {
                        TripMapPinButton(
                            item: item,
                            isSelected: store.selectedItem?.id == item.id,
                            action: {
                                store.send(.view(.markerTapped(item.id)))
                            }
                        )
                    }
                }
            }
        }
        .id(store.mapViewport)
        .ignoresSafeArea(edges: .bottom)
    }
}

private extension Place {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

private extension TripMapViewport.Coordinate {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

private extension TripMapViewport {
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: center.latitude,
                longitude: center.longitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: latitudeDelta,
                longitudeDelta: longitudeDelta
            )
        )
    }
}

#Preview("Multiple Pins") {
    NavigationStack {
        TripMapView(
            store: Store(
                initialState: TripMapFeature.State(trip: .tripMapPreviewTrip)
            ) {
                TripMapFeature()
            }
        )
    }
}

#Preview("One Pin") {
    NavigationStack {
        TripMapView(
            store: Store(
                initialState: TripMapFeature.State(trip: .tripMapSinglePinPreviewTrip)
            ) {
                TripMapFeature()
            }
        )
    }
}

#Preview("Empty") {
    NavigationStack {
        TripMapView(
            store: Store(
                initialState: TripMapFeature.State(trip: .tripMapEmptyPreviewTrip)
            ) {
                TripMapFeature()
            }
        )
    }
}
