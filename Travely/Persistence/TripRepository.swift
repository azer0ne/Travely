import ComposableArchitecture
import Foundation
import SwiftData

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

    static func live(modelContainer: ModelContainer) -> Self {
        let store = SwiftDataTripRepositoryStore(modelContainer: modelContainer)

        return Self(
            fetchTrips: {
                try await store.fetchTrips()
            },
            createTrip: { trip in
                try await store.createTrip(trip)
            },
            deleteTrip: { tripID in
                try await store.deleteTrip(id: tripID)
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
    static let liveValue: Self = {
        do {
            return .live(modelContainer: try TravelyModelContainer.make())
        } catch {
            fatalError("Failed to create SwiftData-backed TripRepository: \(error)")
        }
    }()
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

@ModelActor
private actor SwiftDataTripRepositoryStore {
    func fetchTrips() throws -> [Trip] {
        let descriptor = FetchDescriptor<TripEntity>()
        return try modelContext.fetch(descriptor)
            .map { $0.toDomain() }
            .sorted { lhs, rhs in
                lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
            }
    }

    func createTrip(_ trip: Trip) throws {
        modelContext.insert(TripEntity(trip: trip))
        try modelContext.save()
    }

    func deleteTrip(id tripID: Trip.ID) throws {
        let trip = try fetchTripEntity(id: tripID)
        modelContext.delete(trip)
        try modelContext.save()
    }

    func fetchItineraryItems(tripID: Trip.ID) throws -> [ItineraryItem] {
        let trip = try fetchTripEntity(id: tripID)
        return trip.itineraryItems
            .map { $0.toDomain() }
            .sorted { lhs, rhs in
                if lhs.date != rhs.date {
                    return lhs.date < rhs.date
                }

                return lhs.time < rhs.time
            }
    }

    func addItineraryItem(_ item: ItineraryItem, to tripID: Trip.ID) throws {
        let trip = try fetchTripEntity(id: tripID)

        var itineraryItem = item
        itineraryItem.tripID = tripID

        let entity = ItineraryItemEntity(item: itineraryItem, trip: trip)
        modelContext.insert(entity)
        try modelContext.save()
    }

    func updateItineraryItem(_ item: ItineraryItem, in tripID: Trip.ID) throws {
        let itineraryItem = try fetchItineraryItemEntity(id: item.id, tripID: tripID)

        var updatedItem = item
        updatedItem.tripID = tripID
        itineraryItem.update(from: updatedItem)
        try modelContext.save()
    }

    func deleteItineraryItem(itemID: ItineraryItem.ID, from tripID: Trip.ID) throws {
        let itineraryItem = try fetchItineraryItemEntity(id: itemID, tripID: tripID)

        modelContext.delete(itineraryItem)
        try modelContext.save()
    }

    private func fetchTripEntity(id tripID: Trip.ID) throws -> TripEntity {
        var descriptor = FetchDescriptor<TripEntity>(
            predicate: #Predicate<TripEntity> { trip in
                trip.id == tripID
            }
        )
        descriptor.fetchLimit = 1

        guard let trip = try modelContext.fetch(descriptor).first else {
            throw TripRepositoryError.tripNotFound(tripID)
        }

        return trip
    }

    private func fetchItineraryItemEntity(
        id itemID: ItineraryItem.ID,
        tripID: Trip.ID
    ) throws -> ItineraryItemEntity {
        var descriptor = FetchDescriptor<ItineraryItemEntity>(
            predicate: #Predicate<ItineraryItemEntity> { item in
                item.id == itemID
            }
        )
        descriptor.fetchLimit = 1

        guard let item = try modelContext.fetch(descriptor).first else {
            throw TripRepositoryError.itineraryItemNotFound(itemID, tripID)
        }

        if item.trip?.id != tripID {
            throw TripRepositoryError.itineraryItemNotFound(itemID, tripID)
        }

        return item
    }
}
