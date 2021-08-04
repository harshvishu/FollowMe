//
//  MockLocationProvider.swift
//  FollowMeTests
//
//  Created by harsh vishwakarma on 04/08/21.
//

import Foundation
import Combine
import CoreLocation
import XCTest

@testable import FollowMe

/**
 ### CoreLocationProvider
 Use an instance of CoreLocationProvider to access the userlocation and other location based features
 */
final class MockLocationProvider: NSObject, LocationProviderType {
    
    // MARK: Private properties
    // MARK: Private properties
    private var locationSubject = CurrentValueSubject<CLLocation, Never>(CLLocation())
    private var locationAuthorizationSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.denied)
    
    private var mockLocation: CLLocation
    private var authorizationStatus: CLAuthorizationStatus
    private var timer = Timer()
    
    /**
     - parameter latitude: Default mock latitude = 0.0
     - parameter longitude: Default mock longitude = 0.0
     - parameter authorizationStatus: Default CLAuthorizationStatus = .notDetermined

     ### Overview
     MyMapViewViewModel requires an instane of locationProvider to fetch the current user location
     */
    init(latitude: Double = 0.0, longitude: Double = 0.0, authorizationStatus: CLAuthorizationStatus = .notDetermined) {
        self.mockLocation = CLLocation(latitude: latitude, longitude: longitude)
        self.authorizationStatus = authorizationStatus
    }
    
    
    // MARK: LocationProviderType Implementation
 
    func fetchLocation() -> AnyPublisher<CLLocation, Never> {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.runScheduledTask), userInfo: nil, repeats: true)
        return locationSubject.eraseToAnyPublisher()
    }
    
    func stopFetchingLocation() {
        timer.invalidate()
    }
    
    /// Not implemented for the scope
    func fetchLocationAuthorizationStatus() -> AnyPublisher<CLAuthorizationStatus, Never> {
        locationAuthorizationSubject.eraseToAnyPublisher()
    }
    
    @objc func runScheduledTask() {
        locationSubject.send(mockLocation)
    }
}
