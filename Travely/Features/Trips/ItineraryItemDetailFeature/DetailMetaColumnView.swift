import SwiftUI

struct DetailMetaColumnView: View {
    let label: String
    let systemImage: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appNeutral)
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
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .allowsTightening(true)
                    .layoutPriority(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
