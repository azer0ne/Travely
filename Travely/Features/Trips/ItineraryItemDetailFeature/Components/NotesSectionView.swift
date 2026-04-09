import SwiftUI

struct NotesSectionView: View {
    let notes: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitleView(label: "Notes", systemImage: "note.text")

            Text("\"\(notes)\"")
                .foregroundStyle(.primary)
                .padding(18)
                .background(Color.white.opacity(0.78))
                .clipShape(.rect(cornerRadius: 24))
                .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
        }
    }
}
