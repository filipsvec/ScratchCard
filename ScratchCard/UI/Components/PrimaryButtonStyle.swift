//
//  PrimaryButtonStyle.swift
//  ScratchCard
//
//  Created by Filip Svec on 08/05/2023.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(
                .blue.opacity(configuration.isPressed ? 0.05 : 0.2)
            )
            .cornerRadius(12)
    }
}

extension Button {
    
    func primaryStyle() -> some View {
        buttonStyle(PrimaryButtonStyle())
    }
}
