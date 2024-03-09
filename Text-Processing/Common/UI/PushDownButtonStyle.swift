//
//  PushDownButtonStyle.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 09.03.2024.
//

import SwiftUI

struct PushDownButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeIn(duration: 0.15), value: configuration.isPressed)
    }
}
