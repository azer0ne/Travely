import SwiftUI

struct DateTimeSectionView: View {
    @Binding var selectedDate: Date
    @Binding var selectedTime: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date & Time")
                .font(.headline)
                .foregroundStyle(.primary)

            VStack(spacing: 12) {
                DatePicker(
                    "Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .padding(18)
                .background(.white)
                .clipShape(.rect(cornerRadius: 18))

                DatePicker(
                    "Time",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .padding(18)
                .background(.white)
                .clipShape(.rect(cornerRadius: 18))
            }
        }
    }
}
