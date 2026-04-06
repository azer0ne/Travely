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
            .background(isDisabled ? Color.appSecondary.opacity(0.55) : Color.appPrimary)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 18))
        }
        .disabled(isDisabled)
    }
}
