//
//  PokedexFrameView.swift
//  Created by Manuel Sustaita on 02/07/26.
//  Vista decorativa que envuelve el contenido
//

import SwiftUI

struct PokedexFrameView<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 18) {
            header
            screen
            controls
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(PokedexPalette.bodyRed)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(PokedexPalette.bodyRedDark, lineWidth: 3)
                )
        )
    }

    // MARK: - Header (luces + botón octágono)

    private var header: some View {
        HStack {
            OctagonButton(size: 48)
            Spacer()
            IndicatorLightsView()
        }
    }

    // MARK: - Pantalla (bisel + contenido)

    private var screen: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(PokedexPalette.screenDark)
                .overlay(
                    content
                        .padding(10)
                )
                .frame(maxWidth: .infinity)
                .frame(minHeight: 320)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(PokedexPalette.bezelGray)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(PokedexPalette.bezelGrayDark, lineWidth: 2)
                )
        )
    }

    // MARK: - Controles inferiores

    private var controls: some View {
        HStack(alignment: .center) {
            VStack(spacing: 16) {
                HStack(spacing: 10) {
                    OctagonButton(size: 34)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(PokedexPalette.lightRed)
                        .frame(width: 34, height: 12)
                    Capsule()
                        .fill(PokedexPalette.accentGreen)
                        .frame(width: 44, height: 14)
                }
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(PokedexPalette.accentGreen)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(PokedexPalette.accentGreenDark, lineWidth: 2)
                    )
                    .frame(width: 120, height: 34)
            }

            Spacer()

            DPadView(size: 90)
        }
    }
}

#Preview {
    PokedexFrameView {
        VStack {
            Text("Contenido de ejemplo")
                .foregroundStyle(.white)
        }
    }
    .padding()
}
