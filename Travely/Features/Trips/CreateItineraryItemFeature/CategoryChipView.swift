import SwiftUI

struct CategoryChipView: View {
    let category: ItineraryItemCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(category.title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isSelected ? Color(red: 0.11, green: 0.46, blue: 0.95) : .white)
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(.capsule)
                .overlay {
                    Capsule()
                        .strokeBorder(isSelected ? .clear : Color(red: 0.88, green: 0.9, blue: 0.94))
                }
        }
        .buttonStyle(.plain)
    }
}
