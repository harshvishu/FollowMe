//
//  MyMapView_ViewModel.swift
//  FollowMe
//
//  Created by harsh vishwakarma on 04/08/21.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit

final class MyMapViewViewModel: ObservableObject {
    
    // MARK: Exposed
    @Published var userTrackingMode: MapUserTrackingMode = .follow
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    @Published var showUserLocation = false
    @Published var location: CLLocation?
    @Published var isLocationTrackingStarted = false
    @Published var autorizationStatus: CLAuthorizationStatus = CLAuthorizationStatus.notDetermined
    
    // MARK: Private Properties
    private var locationProvider: LocationProviderType
    private var cancelBag: Set<AnyCancellable> = []
    private var fetchLocationTask: AnyCancellable? {
        didSet {fetchLocationTask?.store(in: &cancelBag)}
    }
    private var fetchAuthorizationStatusTask: AnyCancellable? {
        didSet {fetchAuthorizationStatusTask?.store(in: &cancelBag)}
    }
    
    /**
     - parameter locationProvider: provide instance of `LocationProviderType`
     
     ### Overview
     MyMapViewViewModel requires an instane of locationProvider to fetch the current user location
     */
    init(locationProvider: LocationProviderType) {
        self.locationProvider = locationProvider
    }
    
    /// Start listening to location changes
    /// This also handles the call to system to check for the location usage permission
    func startUpdatingLocation() {
        isLocationTrackingStarted = true    // We have now started the location tracking
        userTrackingMode = .follow          // Location tracking mode based on the requirements
        showUserLocation = true             // Show the current location mark on the maps
        let task = locationProvider.fetchLocation().sink { [weak self] location in
            guard let self = self else {return}
            self.location = location
        }
        self.fetchLocationTask = task       // Keeping reference for later to unsubscribe from the location tracking
    }
    
    /// Stop listening to location updates
    func stopLocationUpdates() {
        fetchLocationTask?.cancel()
        fetchAuthorizationStatusTask?.cancel()
        fetchLocationTask = nil
        fetchAuthorizationStatusTask = nil
        isLocationTrackingStarted = false
        userTrackingMode = .none
        showUserLocation = false
        locationProvider.stopFetchingLocation()
    }
    
    /// Determines weather we have permission to access the user location
    func canShowMyLocation() -> Bool {
        if fetchAuthorizationStatusTask == nil {    // Add a new subscriber
            let task = locationProvider.fetchLocationAuthorizationStatus().sink { [weak self] status in
                guard let self = self else {return}
                self.autorizationStatus = status
            }
            self.fetchAuthorizationStatusTask = task
        }
        
        switch autorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }

    }
    
    /// Returns true if user has opened the app for the first time or has yet to allow/deny the location permission
    func isLocationPermissionNotDetermined() -> Bool {
        return autorizationStatus == .notDetermined
    }
    
}

// MARK: ApplicationSettingsProvider

/// ApplicationSettingsProvider to open user's device settings
extension MyMapViewViewModel: ApplicationSettingsProvider {
    
}
