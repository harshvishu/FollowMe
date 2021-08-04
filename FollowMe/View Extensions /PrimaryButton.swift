//
//  PrimaryButton.swift
//  FollowMe
//
//  Created by harsh vishwakarma on 04/08/21.
//

import SwiftUI

/// Primary button UI configuration
struct PrimaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.title))
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(Color.blue)
            .clipShape(Capsule())
            .foregroundColor(.white)
            .padding()
    }
}
