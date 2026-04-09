import SwiftUI

struct CategoryChipGroupView: View {
    let selectedCategory: ItineraryItemCategory?
    let onCategoryTapped: (ItineraryItemCategory) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.headline)
                .foregroundStyle(.primary)

            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
                ForEach(ItineraryItemCategory.allCases) { category in
                    CategoryChipView(
                        category: category,
                        isSelected: selectedCategory == category,
                        action: {
                            onCategoryTapped(category)
                        }
                    )
                }
            }
        }
    }
}
