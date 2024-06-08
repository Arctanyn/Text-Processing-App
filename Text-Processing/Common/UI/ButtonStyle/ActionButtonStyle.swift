//
//  ActionButtonStyle.swift
//  Text-Processing
//
//  Created by Malil Dugulubgov on 01.05.2024.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    let disabled: Bool
    let backgroundColor: Color
    
    init(disabled: Bool = false, backgroundColor: Color = .teal) {
        self.disabled = disabled
        self.backgroundColor = backgroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
            .opacity(disabled ? 0.5 : 1.0)
            .buttonStyle(PushDownButtonStyle())
    }
}
