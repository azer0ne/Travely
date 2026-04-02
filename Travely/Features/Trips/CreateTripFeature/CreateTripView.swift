import ComposableArchitecture
import PhotosUI
import SwiftUI

struct CreateTripView: View {
    @Bindable var store: StoreOf<CreateTripFeature>
    @State private var selectedPhotoPickerItem: PhotosPickerItem?

    var body: some View {
        Form {
            Section("Cover Image") {
                TripCoverPickerView(
                    imageData: store.selectedImageData,
                    selectedPhotoPickerItem: $selectedPhotoPickerItem,
                    onRemoveTapped: {
                        selectedPhotoPickerItem = nil
                        store.send(.view(.removePhotoTapped))
                    }
                )
            }

            Section("Trip Details") {
                TextField("Name", text: $store.name)
                    .textInputAutocapitalization(.words)

                Toggle("Start Date", isOn: $store.includesStartDate)

                if store.includesStartDate {
                    DatePicker(
                        "Start Date",
                        selection: $store.startDate,
                        displayedComponents: .date
                    )
                }

                Toggle("End Date", isOn: $store.includesEndDate)

                if store.includesEndDate {
                    DatePicker(
                        "End Date",
                        selection: $store.endDate,
                        displayedComponents: .date
                    )
                }
            }

            if let validationMessage = store.validationMessage {
                Section {
                    Text(validationMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Create Trip")
        .onChange(of: selectedPhotoPickerItem) { _, newValue in
            store.send(.view(.photoPickerItemChanged(newValue)))
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    store.send(.view(.cancelTapped))
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    store.send(.view(.saveTapped))
                }
                .disabled(store.isSaving)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateTripView(
            store: Store(initialState: CreateTripFeature.State()) {
                CreateTripFeature()
            }
        )
    }
}
