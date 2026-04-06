import ComposableArchitecture
import SwiftUI

struct TripListView: View {
    @Bindable var store: StoreOf<TripListFeature>

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                TripListHeaderView(
                    tripCount: store.trips.count,
                    isLoading: store.isLoading
                )

                if let errorMessage = store.errorMessage {
                    TripListInlineMessageView(message: errorMessage)
                }

                if store.trips.isEmpty {
                    TripListEmptyStateView(isLoading: store.isLoading)
                } else {
                    ForEach(store.trips) { trip in
                        TripCardView(
                            trip: trip,
                            onDeleteTapped: {
                                store.send(.view(.deleteTripTapped(trip.id)))
                            },
                            onTapped: {
                                store.send(.view(.tripTapped(trip.id)))
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 96)
        }
        .background(Color.appNeutral)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.view(.onAppear))
        }
        .sheet(item: $store.scope(state: \.createTrip, action: \.createTrip)) { store in
            NavigationStack {
                CreateTripView(store: store)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                FloatingCreateTripButton {
                    store.send(.view(.createTripButtonTapped))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            .allowsHitTesting(true)
        }
    }
}

#Preview("Trips") {
    NavigationStack {
        TripListView(
            store: Store(initialState: TripListFeature.State(trips: .tripListPreviewTrips)) {
                TripListFeature()
            }
        )
    }
}

#Preview("Empty") {
    NavigationStack {
        TripListView(
            store: Store(initialState: TripListFeature.State()) {
                TripListFeature()
            }
        )
    }
}
