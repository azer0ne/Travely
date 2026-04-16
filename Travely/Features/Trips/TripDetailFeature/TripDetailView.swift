import ComposableArchitecture
import SwiftUI

struct TripDetailView: View {
    @Bindable var store: StoreOf<TripDetailFeature>

    var body: some View {
        ZStack {
            Color.appNeutral
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    TripDetailHeaderView(trip: store.trip)

                    if store.isLoading && store.itinerarySections.isEmpty {
                        ProgressView("Loading Itinerary")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 48)
                    } else if let errorMessage = store.errorMessage, store.itinerarySections.isEmpty {
                        TripDetailErrorStateView(errorMessage: errorMessage) {
                            store.send(.view(.onAppear))
                        }
                    } else if store.isEmpty {
                        EmptyItineraryView()
                    } else {
                        VStack(alignment: .leading, spacing: 28) {
                            if let errorMessage = store.errorMessage {
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.appTertiary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .background(Color.appTertiary.opacity(0.12))
                                    .clipShape(.rect(cornerRadius: 14))
                            }

                            if store.deletingItemID != nil {
                                ProgressView("Removing itinerary item")
                            }

                            if store.isLoading {
                                ProgressView("Refreshing itinerary")
                            }

                            ForEach(store.itinerarySections.indices, id: \.self) { index in
                                let section = store.itinerarySections[index]
                                ItineraryDaySectionView(
                                    dayNumber: index + 1,
                                    deletingItemID: store.deletingItemID,
                                    isDeleteActionDisabled: store.deletingItemID != nil,
                                    section: section,
                                    onDeleteTapped: { itemID in
                                        store.send(.view(.deleteItineraryItemTapped(itemID)))
                                    },
                                    onItemTapped: { itemID in
                                        store.send(.view(.itineraryItemTapped(itemID)))
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(store.trip.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.view(.onAppear))
        }
        .confirmationDialog(
            "Delete itinerary item?",
            isPresented: Binding(
                get: { store.itemPendingDeletion != nil },
                set: { isPresented in
                    if !isPresented {
                        store.send(.view(.deleteItineraryItemConfirmationDismissed))
                    }
                }
            ),
            titleVisibility: .visible,
            presenting: store.itemPendingDeletion
        ) { _ in
            Button("Delete Item", role: .destructive) {
                store.send(.view(.deleteItineraryItemConfirmed))
            }

            Button("Cancel", role: .cancel) {
                store.send(.view(.deleteItineraryItemConfirmationDismissed))
            }
        } message: { item in
            Text("\"\(item.title)\" will be removed from this trip.")
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()

                FloatingAddPlaceButton {
                    store.send(.view(.addPlaceTapped))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.view(.viewMapTapped))
                } label: {
                    Label("View Map", systemImage: "map")
                }
                .labelStyle(.iconOnly)
            }
        }
        .sheet(item: $store.scope(state: \.createItineraryItem, action: \.createItineraryItem)) { store in
            NavigationStack {
                CreateItineraryItemView(store: store)
            }
        }
    }
}

#Preview("Empty Trip") {
    NavigationStack {
        TripDetailView(
            store: Store(
                initialState: TripDetailFeature.State(
                    trip: Trip(
                        name: "Paris & Versailles",
                        startDate: Date(timeIntervalSince1970: 1_718_150_400),
                        endDate: Date(timeIntervalSince1970: 1_718_496_000)
                    )
                )
            ) {
                TripDetailFeature()
            }
        )
    }
}

#Preview("Trip With Itinerary") {
    NavigationStack {
        TripDetailView(
            store: Store(
                initialState: TripDetailFeature.State(
                    trip: Trip(
                        name: "Paris & Versailles",
                        startDate: Date(timeIntervalSince1970: 1_718_150_400),
                        endDate: Date(timeIntervalSince1970: 1_718_496_000),
                        itineraryItems: [
                            ItineraryItem(
                                title: "Arrive at CDG Airport",
                                category: .transport,
                                date: Date(timeIntervalSince1970: 1_718_150_400),
                                time: Date(timeIntervalSince1970: 1_718_182_800),
                                attachedPlace: Place(
                                    name: "Arrive at CDG Airport",
                                    latitude: 49.0097,
                                    longitude: 2.5479,
                                    address: "95700 Roissy-en-France",
                                    category: "Airport"
                                )
                            ),
                            ItineraryItem(
                                title: "Check-in Hotel Lutetia",
                                category: .hotel,
                                date: Date(timeIntervalSince1970: 1_718_150_400),
                                time: Date(timeIntervalSince1970: 1_718_191_800),
                                attachedPlace: Place(
                                    name: "Check-in Hotel Lutetia",
                                    latitude: 48.8517,
                                    longitude: 2.3255,
                                    address: "45 Boulevard Raspail, Paris",
                                    category: "Hotel"
                                )
                            ),
                            ItineraryItem(
                                title: "Lunch at Le Comptoir",
                                category: .food,
                                date: Date(timeIntervalSince1970: 1_718_150_400),
                                time: Date(timeIntervalSince1970: 1_718_197_200),
                                attachedPlace: Place(
                                    name: "Lunch at Le Comptoir",
                                    latitude: 48.8525,
                                    longitude: 2.3332,
                                    address: "9 Carrefour de l'Odeon, Paris",
                                    category: "Restaurant"
                                )
                            ),
                            ItineraryItem(
                                title: "Morning Museum Tour",
                                category: .activity,
                                date: Date(timeIntervalSince1970: 1_718_236_800),
                                time: Date(timeIntervalSince1970: 1_718_269_200),
                                attachedPlace: Place(
                                    name: "Morning Museum Tour",
                                    latitude: 48.8606,
                                    longitude: 2.3376,
                                    address: "Rue de Rivoli, Paris",
                                    category: "Museum"
                                )
                            ),
                            ItineraryItem(
                                title: "Tuileries Garden Stroll",
                                category: .activity,
                                date: Date(timeIntervalSince1970: 1_718_236_800),
                                time: Date(timeIntervalSince1970: 1_718_283_600),
                                attachedPlace: Place(
                                    name: "Tuileries Garden Stroll",
                                    latitude: 48.8635,
                                    longitude: 2.327,
                                    address: "Place de la Concorde, Paris",
                                    category: "Park"
                                )
                            )
                        ]
                    )
                )
            ) {
                TripDetailFeature()
            }
        )
    }
}
