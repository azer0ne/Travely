import PhotosUI
import SwiftUI

struct TripCoverPickerView: View {
    let imageData: Data?
    @Binding var selectedPhotoPickerItem: PhotosPickerItem?
    let onRemoveTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PhotosPicker(selection: $selectedPhotoPickerItem, matching: .images) {
                TripCoverPreview(imageData: imageData)
            }
            .buttonStyle(.plain)

            HStack {
                PhotosPicker("Choose Image", selection: $selectedPhotoPickerItem, matching: .images)

                if imageData != nil {
                    Button("Remove Image", role: .destructive, action: onRemoveTapped)
                }
            }
        }
    }
}
