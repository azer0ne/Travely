import SwiftUI
import UIKit

struct TripCoverPreview: View {
    let imageData: Data?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.42, green: 0.81, blue: 0.89),
                            Color(red: 0.15, green: 0.54, blue: 0.72)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            if let uiImage = previewImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                    Text("Tap to add a trip image")
                        .font(.subheadline)
                        .bold()
                }
                .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .clipShape(.rect(cornerRadius: 20))
    }

    private var previewImage: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }
}
