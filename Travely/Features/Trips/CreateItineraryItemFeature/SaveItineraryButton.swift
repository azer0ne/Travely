import SwiftUI

struct SaveItineraryButton: View {
    let isDisabled: Bool
    let isSaving: Bool
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                if isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .bold()
                }
                Spacer()
            }
            .padding(.vertical, 18)
            .background(isDisabled ? Color(red: 0.73, green: 0.8, blue: 0.92) : Color(red: 0.11, green: 0.46, blue: 0.95))
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 18))
        }
        .disabled(isDisabled)
    }
}
