//
//  ContentView.swift
//  FollowMe
//
//  Created by harsh vishwakarma on 04/08/21.
//

import SwiftUI
import MapKit

struct MyMapView: View {
    
    @ObservedObject var viewModel = MyMapViewViewModel(locationProvider: CoreLocationProvider())
    
    @ViewBuilder
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(
                coordinateRegion: $viewModel.region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: viewModel.showUserLocation,
                userTrackingMode: $viewModel.userTrackingMode
            )
            
            if canShowLocationButton() {
                // start or stop tracking
                Button(getLocationButtonTitle()) {
                    withAnimation {
                        actionForLocationButton()
                    }
                }
                .modifier(PrimaryButton())
                .accessibility(hint: Text(getAccessibilityForLocationButton()))
                
            } else {
                VStack {
                  
                    Text("Enable location permission")
                        .font(.headline)
                    
                                        
                    Button("Settings") {
                            actionForSettingsButton()
                    }
                    .modifier(PrimaryButton())
                    .accessibility(hint: Text("Opens your application settings"))
                }
            }
        }
    }
    
    /// Get primary button text based on the state of location tracking
    private func getLocationButtonTitle() -> String {
        viewModel.isLocationTrackingStarted ? "STOP" : "START"
    }
    
    private func getAccessibilityForLocationButton() -> String {
        viewModel.isLocationTrackingStarted ? "Stops location updates" : "Starts location updates"
    }
    
    /// Handle the press of start-stop button
    /// If location tracking is started then stop it
    /// Else start the tracking
    private func actionForLocationButton() {
        if viewModel.isLocationTrackingStarted {
            viewModel.stopLocationUpdates()
        } else {
            viewModel.startUpdatingLocation()
        }
    }
    
    /// Open the app settings so that user can change permission
    private func actionForSettingsButton() {
        viewModel.goToAppSettings()
    }
    
    /// Weather or not we can start location tracking
    private func canShowLocationButton() -> Bool {
        viewModel.canShowMyLocation() || viewModel.isLocationPermissionNotDetermined()
    }
}

struct MyMapView_Previews: PreviewProvider {
    static var previews: some View {
        MyMapView()
    }
}
