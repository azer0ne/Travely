import ComposableArchitecture
import SwiftUI

struct ItineraryItemDetailView: View {
    @Bindable var store: StoreOf<ItineraryItemDetailFeature>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ItineraryItemHeaderView(
                    itineraryItem: store.itineraryItem,
                    tripImageData: store.trip.imageData
                )

                if let category = store.itineraryItem.category {
                    ItineraryCategoryBadgeView(category: category)
                }

                Text(store.itineraryItem.title)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.primary)

                DetailMetaSectionView(itineraryItem: store.itineraryItem)

                if let attachedPlace = store.itineraryItem.attachedPlace {
                    LocationSectionView(place: attachedPlace)
                    MapPreviewSectionView(
                        place: attachedPlace,
                        onOpenInMapsTapped: {
                            store.send(.view(.openInMapsTapped))
                        }
                    )
                }

                if store.hasNotes {
                    NotesSectionView(notes: store.itineraryItem.notes)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 32)
        }
        .background(Color(red: 0.96, green: 0.97, blue: 0.99))
        .scrollIndicators(.hidden)
        .navigationTitle("Itinerary Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.view(.onAppear))
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.view(.editTapped))
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .labelStyle(.iconOnly)
            }
        }
        .sheet(item: $store.scope(state: \.editItineraryItem, action: \.editItineraryItem)) { store in
            NavigationStack {
                CreateItineraryItemView(store: store)
            }
        }
    }
}

#Preview("Place Based") {
    NavigationStack {
        ItineraryItemDetailView(
            store: Store(
                initialState: ItineraryItemDetailFeature.State(
                    trip: .parisPreviewTripWithImage,
                    itineraryItem: .louvreMuseumTour
                )
            ) {
                ItineraryItemDetailFeature()
            }
        )
    }
}

#Preview("Custom Activity") {
    NavigationStack {
        ItineraryItemDetailView(
            store: Store(
                initialState: ItineraryItemDetailFeature.State(
                    trip: .parisPreviewTrip,
                    itineraryItem: .trainToCity
                )
            ) {
                ItineraryItemDetailFeature()
            }
        )
    }
}

#Preview("No Notes") {
    NavigationStack {
        ItineraryItemDetailView(
            store: Store(
                initialState: ItineraryItemDetailFeature.State(
                    trip: .parisPreviewTrip,
                    itineraryItem: .museumWalkNoNotes
                )
            ) {
                ItineraryItemDetailFeature()
            }
        )
    }
}

#Preview("Place Fallback Hero") {
    NavigationStack {
        ItineraryItemDetailView(
            store: Store(
                initialState: ItineraryItemDetailFeature.State(
                    trip: .parisPreviewTrip,
                    itineraryItem: .louvreMuseumTour
                )
            ) {
                ItineraryItemDetailFeature()
            }
        )
    }
}
