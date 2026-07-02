//
//  DPadView.swift
//  Created by Manuel Sustaita on 02/07/26.
//  Cruz direccional (D-pad) decorativa
//

import SwiftUI

struct DPadView: View {
    var color: Color = PokedexPalette.accentBlue
    var borderColor: Color = PokedexPalette.accentBlueDark
    var size: CGFloat = 90

    /// Grosor de cada brazo de la cruz, relativo al tamaño total.
    private var armWidth: CGFloat { size * 0.34 }

    var body: some View {
        ZStack {
            crossShape
                .fill(color)
                .overlay(crossShape.stroke(borderColor, lineWidth: 2))

            RoundedRectangle(cornerRadius: 3)
                .fill(.white.opacity(0.9))
                .frame(width: armWidth * 0.4, height: armWidth * 0.4)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
    }

    /// Cruz construida como la unión de dos rectángulos redondeados.
    private var crossShape: some Shape {
        DPadCross(armWidth: armWidth)
    }
}

/// Shape que dibuja una cruz (unión de un rectángulo horizontal y uno vertical).
private struct DPadCross: Shape {
    var armWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        let midX = rect.midX
        let midY = rect.midY
        let half = armWidth / 2
        let corner: CGFloat = 6

        var path = Path()
        let vertical = CGRect(x: midX - half, y: rect.minY, width: armWidth, height: rect.height)
        let horizontal = CGRect(x: rect.minX, y: midY - half, width: rect.width, height: armWidth)

        path.addRoundedRect(in: vertical, cornerSize: CGSize(width: corner, height: corner))
        path.addRoundedRect(in: horizontal, cornerSize: CGSize(width: corner, height: corner))
        return path
    }
}
