import SwiftUI

struct PlaceHeroPlaceholderView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.34, green: 0.45, blue: 0.59),
                    Color(red: 0.96, green: 0.82, blue: 0.62),
                    Color(red: 0.86, green: 0.92, blue: 0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            TriangleShape()
                .fill(.white.opacity(0.78))
                .frame(width: 120, height: 140)

            Rectangle()
                .fill(.white.opacity(0.72))
                .frame(height: 6)
                .padding(.horizontal, 46)
                .offset(y: 64)
        }
    }
}
