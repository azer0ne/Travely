import CoreLocation
import Foundation

@MainActor
final class CoreLocationOneShotRequest: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<(latitude: Double, longitude: Double)?, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func currentCoordinates() async throws -> (latitude: Double, longitude: Double)? {
        guard CLLocationManager.locationServicesEnabled() else {
            return nil
        }

        let status = await resolvedAuthorizationStatus()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return nil
        }

        do {
            return try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { continuation in
                    locationContinuation = continuation
                    manager.requestLocation()
                }
            } onCancel: {
                Task { @MainActor in
                    self.finishLocationRequest(with: nil)
                }
            }
        } catch let error as CLError where error.code == .locationUnknown || error.code == .denied {
            return nil
        }
    }

    private func resolvedAuthorizationStatus() async -> CLAuthorizationStatus {
        let status = manager.authorizationStatus

        guard status == .notDetermined else {
            return status
        }

        return await withTaskCancellationHandler {
            await withCheckedContinuation { continuation in
                authorizationContinuation = continuation
                manager.requestWhenInUseAuthorization()
            }
        } onCancel: {
            Task { @MainActor in
                self.finishAuthorizationRequest(with: self.manager.authorizationStatus)
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        finishAuthorizationRequest(with: manager.authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            finishLocationRequest(with: nil)
            return
        }

        finishLocationRequest(with: (coordinate.latitude, coordinate.longitude))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finishLocationRequest(with: error)
    }

    private func finishAuthorizationRequest(with status: CLAuthorizationStatus) {
        guard let authorizationContinuation else {
            return
        }

        self.authorizationContinuation = nil
        authorizationContinuation.resume(returning: status)
    }

    private func finishLocationRequest(with coordinates: (latitude: Double, longitude: Double)?) {
        guard let locationContinuation else {
            return
        }

        self.locationContinuation = nil
        locationContinuation.resume(returning: coordinates)
    }

    private func finishLocationRequest(with error: Error) {
        guard let locationContinuation else {
            return
        }

        self.locationContinuation = nil
        locationContinuation.resume(throwing: error)
    }
}
