import SwiftUI

struct MapPreviewArtworkView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.86, green: 0.84, blue: 0.71),
                    Color(red: 0.76, green: 0.79, blue: 0.66)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Path { path in
                path.move(to: CGPoint(x: 0, y: 28))
                path.addCurve(
                    to: CGPoint(x: 280, y: 138),
                    control1: CGPoint(x: 78, y: 52),
                    control2: CGPoint(x: 200, y: 110)
                )
            }
            .stroke(Color(red: 0.31, green: 0.63, blue: 0.78), style: StrokeStyle(lineWidth: 18, lineCap: .round))

            GridPatternShape()
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        }
        .clipShape(.rect(cornerRadius: 24))
    }
}
