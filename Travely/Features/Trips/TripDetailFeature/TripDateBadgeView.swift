import SwiftUI

struct TripDateBadgeView: View {
    let trip: Trip

    var body: some View {
        ViewThatFits(in: .horizontal) {
            Text(primaryText)
                .font(.subheadline)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white)
                .clipShape(.capsule)

            Text(compactText)
                .font(.subheadline)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white)
                .clipShape(.capsule)

            Text("Dates TBD")
                .font(.subheadline)
                .bold()
                .lineLimit(1)
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white)
                .clipShape(.capsule)
        }
    }

    private var primaryText: String {
        switch (trip.startDate, trip.endDate) {
        case let (startDate?, endDate?):
            "\(startDate.formatted(.dateTime.month(.abbreviated).day())) - \(endDate.formatted(.dateTime.month(.abbreviated).day().year()))"
        case let (startDate?, nil):
            startDate.formatted(.dateTime.month(.abbreviated).day().year())
        case let (nil, endDate?):
            endDate.formatted(.dateTime.month(.abbreviated).day().year())
        case (nil, nil):
            "Dates TBD"
        }
    }

    private var compactText: String {
        switch (trip.startDate, trip.endDate) {
        case let (startDate?, endDate?):
            let calendar = Calendar.autoupdatingCurrent

            if calendar.isDate(startDate, equalTo: endDate, toGranularity: .year) {
                if calendar.isDate(startDate, equalTo: endDate, toGranularity: .month) {
                    return "\(startDate.formatted(.dateTime.month(.abbreviated).day()))-\(endDate.formatted(.dateTime.day().year()))"
                }

                return "\(startDate.formatted(.dateTime.month(.abbreviated).day()))-\(endDate.formatted(.dateTime.month(.abbreviated).day().year()))"
            }

            return "\(startDate.formatted(.dateTime.month(.abbreviated).day().year()))-\(endDate.formatted(.dateTime.month(.abbreviated).day().year()))"

        case let (startDate?, nil):
            return startDate.formatted(.dateTime.month(.abbreviated).day().year())

        case let (nil, endDate?):
            return endDate.formatted(.dateTime.month(.abbreviated).day().year())

        case (nil, nil):
            return "Dates TBD"
        }
    }
}
