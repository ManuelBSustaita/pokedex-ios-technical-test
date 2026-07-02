//
//  Octagon.swift
//  Created by Manuel Sustaita on 02/07/26.
//  Shape custom que dibuja un octágono a partir de un rect,cortando las 4 esquinas en diagonal.
//

import SwiftUI

struct Octagon: Shape {
    /// Porcentaje del lado más corto que se "corta" en cada esquina.
    var cutRatio: CGFloat = 0.3

    func path(in rect: CGRect) -> Path {
        let side = min(rect.width, rect.height)
        let cut = side * cutRatio

        let minX = rect.minX
        let minY = rect.minY
        let maxX = rect.maxX
        let maxY = rect.maxY

        var path = Path()
        path.move(to: CGPoint(x: minX + cut, y: minY))
        path.addLine(to: CGPoint(x: maxX - cut, y: minY))
        path.addLine(to: CGPoint(x: maxX, y: minY + cut))
        path.addLine(to: CGPoint(x: maxX, y: maxY - cut))
        path.addLine(to: CGPoint(x: maxX - cut, y: maxY))
        path.addLine(to: CGPoint(x: minX + cut, y: maxY))
        path.addLine(to: CGPoint(x: minX, y: maxY - cut))
        path.addLine(to: CGPoint(x: minX, y: minY + cut))
        path.closeSubpath()
        return path
    }
}

#Preview {
    Octagon()
        .fill(.blue)
        .frame(width: 100, height: 100)
        .padding()
}
