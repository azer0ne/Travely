import Foundation

extension [Trip] {
    static let tripListPreviewTrips: [Trip] = [
        Trip(
            name: "Amalfi Coast Getaway",
            startDate: .previewOffset(days: 12),
            endDate: .previewOffset(days: 19),
            itineraryItems: [
                ItineraryItem(
                    title: "Positano Beach",
                    category: .activity,
                    attachedPlace: Place(
                        name: "Positano Beach",
                        latitude: 40.627,
                        longitude: 14.484,
                        address: "Positano, Italy"
                    )
                ),
                ItineraryItem(
                    title: "Path of the Gods",
                    category: .activity,
                    attachedPlace: Place(
                        name: "Path of the Gods",
                        latitude: 40.630,
                        longitude: 14.540,
                        address: "Agerola, Italy"
                    )
                )
            ]
        ),
        Trip(
            name: "Kyoto Traditions",
            startDate: .previewOffset(months: 7),
            endDate: .previewOffset(months: 7, days: 9),
            itineraryItems: [
                ItineraryItem(
                    title: "Fushimi Inari Taisha",
                    category: .activity,
                    attachedPlace: Place(
                        name: "Fushimi Inari Taisha",
                        latitude: 34.967,
                        longitude: 135.772,
                        address: "Kyoto, Japan"
                    )
                )
            ]
        ),
        Trip(
            name: "Parisian Winter",
            startDate: .previewOffset(months: 10),
            endDate: .previewOffset(months: 10, days: 6),
            itineraryItems: []
        ),
        Trip(
            name: "Dubai Stopover",
            startDate: .previewOffset(months: 8),
            endDate: .previewOffset(months: 8, days: 1),
            itineraryItems: []
        )
    ]
}

private extension Date {
    static func previewOffset(months: Int = 0, days: Int = 0) -> Date {
        let calendar = Calendar.current
        let withMonths = calendar.date(byAdding: .month, value: months, to: .now) ?? .now
        return calendar.date(byAdding: .day, value: days, to: withMonths) ?? withMonths
    }
}
