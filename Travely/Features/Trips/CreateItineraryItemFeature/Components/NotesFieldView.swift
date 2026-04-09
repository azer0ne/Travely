import SwiftUI

struct NotesFieldView: View {
    @Binding var notes: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(.headline)
                .foregroundStyle(.primary)

            TextField("Optional notes", text: $notes, axis: .vertical)
                .lineLimit(4...)
                .textInputAutocapitalization(.sentences)
                .padding(18)
                .background(.white)
                .clipShape(.rect(cornerRadius: 20))
        }
    }
}
