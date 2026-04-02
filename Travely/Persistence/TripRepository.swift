import ComposableArchitecture
import Foundation

struct TripRepository {
    var fetchTrips: @Sendable () async throws -> [Trip]
    var createTrip: @Sendable (_ trip: Trip) async throws -> Void
    var deleteTrip: @Sendable (_ tripID: Trip.ID) async throws -> Void
    var fetchItineraryItems: @Sendable (_ tripID: Trip.ID) async throws -> [ItineraryItem]
    var addItineraryItem: @Sendable (_ item: ItineraryItem, _ tripID: Trip.ID) async throws -> Void
    var updateItineraryItem: @Sendable (_ item: ItineraryItem, _ tripID: Trip.ID) async throws -> Void
    var deleteItineraryItem: @Sendable (_ itemID: ItineraryItem.ID, _ tripID: Trip.ID) async throws -> Void
}

enum TripRepositoryError: Error {
    case itineraryItemNotFound(ItineraryItem.ID, Trip.ID)
    case tripNotFound(Trip.ID)
}

extension TripRepository {
    static func inMemory(initialTrips: [Trip] = []) -> Self {
        let store = InMemoryTripRepositoryStore(initialTrips: initialTrips)

        return Self(
            fetchTrips: {
                await store.fetchTrips()
            },
            createTrip: { trip in
                await store.createTrip(trip)
            },
            deleteTrip: { tripID in
                await store.deleteTrip(id: tripID)
            },
            fetchItineraryItems: { tripID in
                try await store.fetchItineraryItems(tripID: tripID)
            },
            addItineraryItem: { item, tripID in
                try await store.addItineraryItem(item, to: tripID)
            },
            updateItineraryItem: { item, tripID in
                try await store.updateItineraryItem(item, in: tripID)
            },
            deleteItineraryItem: { itemID, tripID in
                try await store.deleteItineraryItem(itemID: itemID, from: tripID)
            }
        )
    }
}

extension TripRepository: DependencyKey {
    // Temporary live behavior until a SwiftData-backed implementation is injected.
    static let liveValue = Self.inMemory()
    static let previewValue = Self.inMemory()
    static let testValue = Self.inMemory()
}

extension DependencyValues {
    var tripRepository: TripRepository {
        get { self[TripRepository.self] }
        set { self[TripRepository.self] = newValue }
    }
}

private actor InMemoryTripRepositoryStore {
    private var tripsByID: [Trip.ID: Trip]

    init(initialTrips: [Trip]) {
        self.tripsByID = Dictionary(
            uniqueKeysWithValues: initialTrips.map { ($0.id, $0) }
        )
    }

    func fetchTrips() -> [Trip] {
        tripsByID.values.sorted { lhs, rhs in
            lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
        }
    }

    func createTrip(_ trip: Trip) {
        tripsByID[trip.id] = trip
    }

    func deleteTrip(id tripID: Trip.ID) {
        tripsByID.removeValue(forKey: tripID)
    }

    func fetchItineraryItems(tripID: Trip.ID) throws -> [ItineraryItem] {
        guard let trip = tripsByID[tripID] else {
            throw TripRepositoryError.tripNotFound(tripID)
        }

        return trip.itineraryItems
    }

    func addItineraryItem(_ item: ItineraryItem, to tripID: Trip.ID) throws {
        guard var trip = tripsByID[tripID] else {
            throw TripRepositoryError.tripNotFound(tripID)
        }

        var itineraryItem = item
        itineraryItem.tripID = tripID
        trip.itineraryItems.append(itineraryItem)
        tripsByID[tripID] = trip
    }

    func updateItineraryItem(_ item: ItineraryItem, in tripID: Trip.ID) throws {
        guard var trip = tripsByID[tripID] else {
            throw TripRepositoryError.tripNotFound(tripID)
        }

        guard let index = trip.itineraryItems.firstIndex(where: { $0.id == item.id }) else {
            throw TripRepositoryError.itineraryItemNotFound(item.id, tripID)
        }

        var itineraryItem = item
        itineraryItem.tripID = tripID
        trip.itineraryItems[index] = itineraryItem
        tripsByID[tripID] = trip
    }

    func deleteItineraryItem(itemID: ItineraryItem.ID, from tripID: Trip.ID) throws {
        guard var trip = tripsByID[tripID] else {
            throw TripRepositoryError.tripNotFound(tripID)
        }

        trip.itineraryItems.removeAll { $0.id == itemID }
        tripsByID[tripID] = trip
    }
}
