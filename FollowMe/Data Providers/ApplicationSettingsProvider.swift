//
//  ApplicationSettingsProvider.swift
//  FollowMe
//
//  Created by harsh vishwakarma on 04/08/21.
//

import UIKit

/**
 ### ApplicationSettingsProvider
 Use an implementatin of  `ApplicationSettingsProvider ` to access device settings
 */
protocol ApplicationSettingsProvider {
    func goToAppSettings()
}

extension ApplicationSettingsProvider {
    /// Default implementation opens the user's device settings
    func goToAppSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
