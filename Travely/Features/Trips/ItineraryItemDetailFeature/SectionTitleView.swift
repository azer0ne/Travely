import SwiftUI

struct SectionTitleView: View {
    let label: String
    let systemImage: String

    var body: some View {
        Label(label, systemImage: systemImage)
            .font(.headline)
            .foregroundStyle(.secondary)
    }
}
