import SwiftUI

struct LocationSectionView: View {
    let place: Place

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitleView(label: "Location", systemImage: "mappin.circle.fill")

            HStack(alignment: .center, spacing: 14) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appNeutral)
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(Color.appPrimary)
                    }

                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Text(place.name)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.primary)
                        
                        Spacer(minLength: 0)
                        
                        if let category = place.category, !category.isEmpty {
                            Text(category)
                                .font(.caption)
                                .bold()
                                .foregroundStyle(Color.appPrimary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.appPrimary.opacity(0.12))
                                .clipShape(.capsule)
                                .lineLimit(1)
                        }
                    }

                    HStack(alignment: .top, spacing: 8) {
                        Text(place.address)
                            .font(.subheadline)
                            .foregroundStyle(Color.appSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Image(systemName: "location")
                            .font(.caption)
                            .foregroundStyle(Color.appSecondary)
                            .padding(.top, 3)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Address \(place.address)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            }
            .padding(18)
            .background(.white)
            .clipShape(.rect(cornerRadius: 24))
            .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
        }
    }
}
