//
//  CoreLocationProvider.swift
//  FollowMe
//
//  Created by harsh vishwakarma on 04/08/21.
//

import Foundation
import CoreLocation
import Combine

/**
 ### CoreLocationProvider
 Use an instance of CoreLocationProvider to access the userlocation and other location based features
 */
final class CoreLocationProvider: NSObject, LocationProviderType {
    
    // MARK: Private properties
    private let locationManager: CLLocationManager
    private var locationSubject = CurrentValueSubject<CLLocation, Never>(CLLocation())
    private var locationAuthorizationSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.denied)
    
    var locationAcuracy: CLLocationAccuracy {
        get {locationManager.desiredAccuracy}
        set {locationManager.desiredAccuracy = newValue}
    }
    
    /**
     ### Overview
     This implementation uses`CLLocationManager` for providing `LocationProviderType` features
     Using `kCLLocationAccuracyBestForNavigation` for this implementation as we want accuracy for location tracking
     */
    override init() {
        self.locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    // MARK: LocationProviderType Implementation
 
    func fetchLocation() -> AnyPublisher<CLLocation, Never> {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        if let location = locationManager.location {
            locationSubject.send(location)
        }
        return locationSubject.eraseToAnyPublisher()
    }
    
    func stopFetchingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func fetchLocationAuthorizationStatus() -> AnyPublisher<CLAuthorizationStatus, Never> {
        locationManager.delegate = self
        locationAuthorizationSubject.send(locationManager.authorizationStatus)
        return locationAuthorizationSubject.eraseToAnyPublisher()
    }
   
}

// MARK: CLLocationManagerDelegate
extension CoreLocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastKnownLocation = locations.last else { return}
        self.locationSubject.send(lastKnownLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Location manager did fail with error: \(error.localizedDescription)")
        locationManager.stopUpdatingLocation()
        locationAuthorizationSubject.send(.denied)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        debugPrint("Location manager policy did change: \(status)")
        locationAuthorizationSubject.send(status)
    }
}
