import Foundation

extension Trip {
    static let tripMapPreviewTrip = Trip(
        name: "Paris & Versailles",
        startDate: Date(timeIntervalSince1970: 1_718_150_400),
        endDate: Date(timeIntervalSince1970: 1_718_496_000),
        itineraryItems: [
            ItineraryItem(
                title: "Arrive at CDG Airport",
                category: .transport,
                date: Date(timeIntervalSince1970: 1_718_150_400),
                time: Date(timeIntervalSince1970: 1_718_182_800),
                attachedPlace: Place(
                    name: "Charles de Gaulle Airport",
                    latitude: 49.0097,
                    longitude: 2.5479,
                    address: "95700 Roissy-en-France",
                    category: "Airport"
                )
            ),
            ItineraryItem(
                title: "Hotel Check-in",
                category: .hotel,
                date: Date(timeIntervalSince1970: 1_718_150_400),
                time: Date(timeIntervalSince1970: 1_718_191_800),
                attachedPlace: Place(
                    name: "Hotel Lutetia",
                    latitude: 48.8517,
                    longitude: 2.3255,
                    address: "45 Boulevard Raspail, Paris",
                    category: "Hotel"
                )
            ),
            ItineraryItem(
                title: "Louvre Museum Tour",
                category: .activity,
                date: Date(timeIntervalSince1970: 1_718_236_800),
                time: Date(timeIntervalSince1970: 1_718_269_200),
                attachedPlace: Place(
                    name: "Musee du Louvre",
                    latitude: 48.8606,
                    longitude: 2.3376,
                    address: "Rue de Rivoli, Paris",
                    category: "Museum"
                )
            )
        ]
    )

    static let tripMapSinglePinPreviewTrip = Trip(
        name: "Solo Stopover",
        itineraryItems: [
            ItineraryItem(
                title: "Coffee Break",
                category: .food,
                date: Date(timeIntervalSince1970: 1_718_150_400),
                time: Date(timeIntervalSince1970: 1_718_182_800),
                attachedPlace: Place(
                    name: "Cafes Richard",
                    latitude: 48.8663,
                    longitude: 2.3211,
                    address: "Paris, France",
                    category: "Cafe"
                )
            )
        ]
    )

    static let tripMapEmptyPreviewTrip = Trip(
        name: "Planning Weekend",
        itineraryItems: [
            ItineraryItem(
                title: "Pack luggage",
                category: .activity,
                date: Date(timeIntervalSince1970: 1_718_150_400),
                time: Date(timeIntervalSince1970: 1_718_182_800),
                notes: "Leave room for souvenirs."
            )
        ]
    )
}
