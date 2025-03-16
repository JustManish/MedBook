//
//  PrimaryButtonStyle.swift
//  MedBook
//
//  Created by Manish Patidar on 14/03/25.
//

import SwiftUI

//MARK: PrimaryButtonStyle
struct PrimaryButtonStyle: ButtonStyle {
    var borderColor: Color
    var textColor: Color
    var backgroundColor: Color
    var cornerRadius: CGFloat

    init(borderColor: Color = .primary,
         textColor: Color = .primary,
         backgroundColor: Color = .clear,
         cornerRadius: CGFloat = 10) {
        self.borderColor = borderColor
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 32)
            .padding(.vertical, 10)
            .foregroundColor(textColor)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: 1)
                    )
            )
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}
