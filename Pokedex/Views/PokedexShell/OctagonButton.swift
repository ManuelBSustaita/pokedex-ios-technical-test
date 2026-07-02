//
//  OctagonButton.swift
//  Created by Manuel Sustaita on 02/07/26.
//  Botón con silueta de octágono
//

import SwiftUI

struct OctagonButton: View {
    var fillColor: Color = PokedexPalette.accentBlue
    var borderColor: Color = PokedexPalette.accentBlueDark
    var size: CGFloat = 60
    var borderWidth: CGFloat = 3
    var action: (() -> Void)? = nil

    var body: some View {
        Group {
            if let action {
                Button(action: action) { shape }
                    .buttonStyle(.plain)
            } else {
                shape
            }
        }
    }

    private var shape: some View {
        Octagon()
            .fill(fillColor)
            .overlay(Octagon().stroke(borderColor, lineWidth: borderWidth))
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
    }
}
