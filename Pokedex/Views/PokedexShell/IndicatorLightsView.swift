//
//  IndicatorLightsView.swift
//  Created by Manuel Sustaita on 02/07/26.
//  Las 3 lucecitas pequeñas (rojo, amarillo, verde) de la parte superior de la carcasa
//

import SwiftUI

struct IndicatorLightsView: View {
    var lightSize: CGFloat = 12
    var spacing: CGFloat = 6

    private let colors: [Color] = [
        PokedexPalette.lightRed,
        PokedexPalette.lightYellow,
        PokedexPalette.lightGreen
    ]

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                RoundedRectangle(cornerRadius: 3)
                    .fill(color)
                    .frame(width: lightSize, height: lightSize)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(.black.opacity(0.15), lineWidth: 1)
                    )
            }
        }
    }
}

