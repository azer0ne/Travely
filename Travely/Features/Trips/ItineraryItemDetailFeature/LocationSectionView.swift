import SwiftUI

struct LocationSectionView: View {
    let place: Place

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitleView(label: "Location", systemImage: "mappin.circle.fill")

            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.95, green: 0.96, blue: 0.99))
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.blue)
                    }

                Text(place.address)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)
            }
            .padding(18)
            .background(.white)
            .clipShape(.rect(cornerRadius: 24))
            .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
        }
    }
}
