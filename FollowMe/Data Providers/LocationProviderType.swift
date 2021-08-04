//
//  LocationProviderType.swift
//  FollowMe
//
//  Created by harsh vishwakarma on 04/08/21.
//

import CoreLocation
import Combine


/**
 ### LocationProviderType
 Conform a class to LocationProviderType to use location based features
 */
public protocol LocationProviderType: AnyObject {
    func fetchLocation() -> AnyPublisher<CLLocation, Never>
    func stopFetchingLocation()
    func fetchLocationAuthorizationStatus() -> AnyPublisher<CLAuthorizationStatus, Never>
}
