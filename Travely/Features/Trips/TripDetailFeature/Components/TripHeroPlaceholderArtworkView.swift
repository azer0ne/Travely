import SwiftUI

struct TripHeroPlaceholderArtworkView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.30, green: 0.36, blue: 0.57),
                    Color(red: 0.88, green: 0.71, blue: 0.77),
                    Color(red: 0.97, green: 0.87, blue: 0.76)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 0) {
                Spacer()

                Rectangle()
                    .fill(.black.opacity(0.15))
                    .frame(height: 46)
            }

            Rectangle()
                .fill(.white.opacity(0.78))
                .frame(width: 8, height: 118)
                .offset(y: -4)

            Rectangle()
                .fill(.white.opacity(0.74))
                .frame(width: 54, height: 4)
                .offset(y: -52)

            TriangleShape()
                .fill(.white.opacity(0.82))
                .frame(width: 92, height: 110)
                .offset(y: -22)
        }
    }
}
