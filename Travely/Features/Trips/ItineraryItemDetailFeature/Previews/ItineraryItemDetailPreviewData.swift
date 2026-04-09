import Foundation

extension ItineraryItem {
    static let louvreMuseumTour = ItineraryItem(
        title: "Louvre Museum Tour",
        category: .activity,
        date: Date(timeIntervalSince1970: 1_729_728_000),
        time: Date(timeIntervalSince1970: 1_729_764_000),
        notes: "Meet the guide at the Glass Pyramid entrance. Arrive 15 minutes early.",
        attachedPlace: Place(
            name: "Musee du Louvre",
            latitude: 48.8606,
            longitude: 2.3376,
            address: "Musee du Louvre, 75001 Paris, France",
            category: "Museum"
        )
    )

    static let trainToCity = ItineraryItem(
        title: "Train to City",
        category: .transport,
        date: Date(timeIntervalSince1970: 1_729_814_400),
        time: Date(timeIntervalSince1970: 1_729_844_200),
        notes: "Tickets are in the wallet. Platform 4B."
    )

    static let museumWalkNoNotes = ItineraryItem(
        title: "Museum Walk",
        category: .activity,
        date: Date(timeIntervalSince1970: 1_729_900_800),
        time: Date(timeIntervalSince1970: 1_729_934_400)
    )
}

extension Trip {
    static let parisPreviewTrip = Trip(
        name: "Paris & Versailles",
        startDate: Date(timeIntervalSince1970: 1_729_641_600),
        endDate: Date(timeIntervalSince1970: 1_729_900_800),
        itineraryItems: [.louvreMuseumTour, .trainToCity, .museumWalkNoNotes]
    )

    static let parisPreviewTripWithImage = Trip(
        imageData: Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwnwEIAgMBR5caXwAAAABJRU5ErkJggg=="),
        name: "Paris & Versailles",
        startDate: Date(timeIntervalSince1970: 1_729_641_600),
        endDate: Date(timeIntervalSince1970: 1_729_900_800),
        itineraryItems: [.louvreMuseumTour, .trainToCity, .museumWalkNoNotes]
    )
}
