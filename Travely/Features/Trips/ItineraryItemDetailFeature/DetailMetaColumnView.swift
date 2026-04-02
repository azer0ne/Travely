import SwiftUI

struct DetailMetaColumnView: View {
    let label: String
    let systemImage: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.95, green: 0.96, blue: 0.99))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: systemImage)
                        .foregroundStyle(.secondary)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
