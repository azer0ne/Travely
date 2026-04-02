import SwiftUI

struct GridPatternShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        stride(from: rect.minX, through: rect.maxX, by: rect.width / 6).forEach { x in
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }

        stride(from: rect.minY, through: rect.maxY, by: rect.height / 5).forEach { y in
            path.move(to: CGPoint(x: rect.minX, y: y))
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }

        return path
    }
}
