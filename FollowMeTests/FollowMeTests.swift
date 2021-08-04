//
//  FollowMeTests.swift
//  FollowMeTests
//
//  Created by harsh vishwakarma on 04/08/21.
//

import XCTest
import CoreLocation
import Combine
@testable import FollowMe

class FollowMeTests: XCTestCase {
    private var sut: LocationProviderType!
    private var cancelBag: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        sut = MockLocationProvider(latitude: 0.0, longitude: 0.0)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFetchLocation() throws {
        let exp = expectation(description: "Mock location every seconds")
        var testLocation: CLLocation?
        
        sut.fetchLocation().sink { location in
            testLocation = location
        }.store(in: &cancelBag)
        
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(testLocation, "Location should not be nil")
        } else {
            XCTFail("Did not complete in 5 seconds")
        }
    }
    
    func testStopLocation() throws {
        let exp = expectation(description: "Location should not be updated once we have stopped")
        var testLocation: CLLocation?
        
        sut.fetchLocation().sink { location in
            testLocation = location
        }.store(in: &cancelBag)     // Start initial fetch 
        sut.stopFetchingLocation()  // Stopped further udates
        testLocation = nil          // Removed existing location
        
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNil(testLocation, "Location should be nil")
        } else {
            XCTFail("Did not complete in 5 seconds")
        }
    }
    
    func testAuthorizationStatus() throws {
        let exp = expectation(description: "authorizationStatus should be .denied")
        var testStatus: CLAuthorizationStatus?
        
        sut = MockLocationProvider(authorizationStatus: .denied)
        sut.fetchLocationAuthorizationStatus().sink { status in
            testStatus = status
        }.store(in: &cancelBag)
        
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(CLAuthorizationStatus.denied, testStatus)
        } else {
            XCTFail("Did not complete in 5 seconds")
        }
    }
}
