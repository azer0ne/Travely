import ComposableArchitecture
import SwiftUI

struct CreateItineraryItemView: View {
    @Bindable var store: StoreOf<CreateItineraryItemFeature>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                CreateItineraryItemHeaderView(title: $store.title)

                LocationAttachmentRowView(
                    attachedPlace: store.attachedPlace,
                    onRemoveTapped: {
                        store.send(.view(.removeLocationTapped))
                    },
                    onTapped: {
                        store.send(.view(.locationTapped))
                    }
                )

                CategoryChipGroupView(
                    selectedCategory: store.selectedCategory,
                    onCategoryTapped: { category in
                        store.send(.view(.categoryTapped(category)))
                    }
                )

                DateTimeSectionView(
                    selectedDate: $store.selectedDate,
                    selectedTime: $store.selectedTime
                )

                NotesFieldView(notes: $store.notes)

                if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(Color(red: 0.96, green: 0.97, blue: 0.99))
        .navigationTitle(store.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    store.send(.view(.cancelTapped))
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            SaveItineraryButton(
                isDisabled: store.isSaveDisabled,
                isSaving: store.isSaving,
                title: store.saveButtonTitle,
                action: {
                    store.send(.view(.saveTapped))
                }
            )
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(.ultraThinMaterial)
        }
        .sheet(item: $store.scope(state: \.locationSearch, action: \.locationSearch)) { store in
            NavigationStack {
                LocationSearchView(store: store)
            }
        }
    }
}

#Preview("Default") {
    NavigationStack {
        CreateItineraryItemView(
            store: Store(
                initialState: CreateItineraryItemFeature.State(
                    trip: Trip(name: "Paris & Versailles")
                )
            ) {
                CreateItineraryItemFeature()
            }
        )
    }
}

#Preview("Selected Category") {
    NavigationStack {
        CreateItineraryItemView(
            store: Store(
                initialState: {
                    var state = CreateItineraryItemFeature.State(
                        trip: Trip(name: "Paris & Versailles")
                    )
                    state.title = "Hotel check-in"
                    state.selectedCategory = .hotel
                    return state
                }()
            ) {
                CreateItineraryItemFeature()
            }
        )
    }
}

#Preview("Attached Place") {
    NavigationStack {
        CreateItineraryItemView(
            store: Store(
                initialState: {
                    var state = CreateItineraryItemFeature.State(
                        trip: Trip(name: "Paris & Versailles")
                    )
                    state.title = "Lunch reservation"
                    state.selectedCategory = .food
                    state.attachedPlace = Place(
                        name: "Le Comptoir",
                        latitude: 48.8525,
                        longitude: 2.3332,
                        address: "9 Carrefour de l'Odeon, Paris",
                        category: "Restaurant"
                    )
                    return state
                }()
            ) {
                CreateItineraryItemFeature()
            }
        )
    }
}

#Preview("Disabled Save") {
    NavigationStack {
        CreateItineraryItemView(
            store: Store(
                initialState: {
                    var state = CreateItineraryItemFeature.State(
                        trip: Trip(name: "Paris & Versailles")
                    )
                    state.title = "   "
                    return state
                }()
            ) {
                CreateItineraryItemFeature()
            }
        )
    }
}
