import SwiftUI

struct TripCardView: View {
    let isDeleteActionDisabled: Bool
    let isDeleting: Bool
    let trip: Trip
    let onDeleteTapped: () -> Void
    let onTapped: () -> Void

    var body: some View {
        Button(action: onTapped) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    TripCardArtworkView(
                        seedText: trip.name,
                        imageData: trip.imageData
                    )
                        .frame(height: 150)

                    if let badgeText {
                        Text(badgeText)
                            .font(.caption2)
                            .bold()
                            .foregroundStyle(Color.appPrimary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.white)
                            .clipShape(.capsule)
                            .padding(12)
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trip.name)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.primary)

                        Text(subtitleText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 12) {
                        if trip.itineraryItems.isEmpty {
                            TripCardMetaPill(
                                text: "No places yet",
                                systemImage: "calendar.badge.plus"
                            )
                        } else {
                            TripCardParticipantsView(count: trip.itineraryItems.count)
                        }

                        Spacer()

                        if isDeleting {
                            ProgressView()
                                .controlSize(.small)
                                .tint(Color.appPrimary)
                                .frame(width: 32, height: 32)
                                .background(Color.appPrimary.opacity(0.08))
                                .clipShape(.circle)
                        } else {
                            Menu {
                                Button("Delete Trip", role: .destructive, action: onDeleteTapped)
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.headline)
                                    .foregroundStyle(Color.appPrimary)
                                    .frame(width: 32, height: 32)
                                    .background(Color.appPrimary.opacity(0.08))
                                    .clipShape(.circle)
                            }
                            .buttonStyle(.plain)
                            .disabled(isDeleteActionDisabled)
                        }
                    }
                }
                .padding(18)
                .background(.white)
            }
            .background(.white)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(color: .black.opacity(0.05), radius: 16, y: 8)
        }
        .buttonStyle(.plain)
    }

    private var subtitleText: String {
        switch (trip.startDate, trip.endDate) {
        case let (startDate?, endDate?):
            "\(startDate.formatted(date: .abbreviated, time: .omitted)) - \(endDate.formatted(date: .abbreviated, time: .omitted))"
        case let (startDate?, nil):
            startDate.formatted(date: .abbreviated, time: .omitted)
        case (nil, _):
            "Dates to be planned"
        }
    }

    private var badgeText: String? {
        guard let startDate = trip.startDate else {
            return nil
        }

        let days = Calendar.current.dateComponents([.day], from: .now, to: startDate).day ?? 0

        guard days >= 0 else {
            return startDate.formatted(.dateTime.month(.abbreviated).year())
        }

        if days <= 21 {
            return "IN \(days) DAYS"
        }

        return startDate.formatted(.dateTime.month(.abbreviated).year())
    }
}

private struct TripCardArtworkView: View {
    let seedText: String
    let imageData: Data?

    var body: some View {
        ZStack {
            if let uiImage = artworkImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholderArtwork
            }
        }
        .clipShape(.rect(cornerRadius: 20))
    }

    private var artworkImage: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }

    @ViewBuilder
    private var placeholderArtwork: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        VStack(spacing: 0) {
            Spacer()

            HStack(alignment: .bottom, spacing: 6) {
                ForEach(0..<6, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white.opacity(0.18))
                        .frame(width: 22, height: CGFloat(24 + index * 12))
                }

                Spacer()

                RoundedRectangle(cornerRadius: 6)
                    .fill(.white.opacity(0.22))
                    .frame(width: 30, height: 76)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 18)
        }

        VStack {
            Spacer()

            Capsule()
                .fill(.white.opacity(0.9))
                .frame(width: 110, height: 8)
                .offset(y: -20)
        }

        CloudShape()
            .fill(.white.opacity(0.85))
            .frame(width: 92, height: 42)
            .offset(x: 36, y: -42)

        Rectangle()
            .fill(.white.opacity(0.88))
            .frame(width: 4, height: 108)
            .offset(x: 8, y: -18)

        Rectangle()
            .fill(.white.opacity(0.88))
            .frame(width: 64, height: 3)
            .offset(x: 34, y: -54)
    }

    private var gradientColors: [Color] {
        switch seedText.hashValue % 3 {
        case 0:
            [Color(red: 0.39, green: 0.78, blue: 0.87), Color(red: 0.13, green: 0.55, blue: 0.73)]
        case 1:
            [Color(red: 0.19, green: 0.73, blue: 0.78), Color(red: 0.19, green: 0.58, blue: 0.72)]
        default:
            [Color(red: 0.21, green: 0.79, blue: 0.88), Color(red: 0.08, green: 0.49, blue: 0.71)]
        }
    }
}

private struct TripCardMetaPill: View {
    let text: String
    let systemImage: String

    var body: some View {
        Label(text, systemImage: systemImage)
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.appNeutral)
            .clipShape(.capsule)
    }
}

private struct TripCardParticipantsView: View {
    let count: Int

    var body: some View {
        HStack(spacing: -8) {
            ForEach(0..<min(count, 3), id: \.self) { index in
                Circle()
                    .fill(colors[index])
                    .stroke(.white, lineWidth: 2)
                    .frame(width: 28, height: 28)
                    .overlay {
                        Image(systemName: icons[index])
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }
            }
        }
    }

    private let colors: [Color] = [.orange, .teal, .blue]
    private let icons: [String] = ["fork.knife", "camera.fill", "figure.walk"]
}

private struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addEllipse(in: CGRect(x: rect.minX + rect.width * 0.12, y: rect.minY + rect.height * 0.24, width: rect.width * 0.28, height: rect.height * 0.46))
        path.addEllipse(in: CGRect(x: rect.minX + rect.width * 0.34, y: rect.minY + rect.height * 0.06, width: rect.width * 0.34, height: rect.height * 0.56))
        path.addEllipse(in: CGRect(x: rect.minX + rect.width * 0.54, y: rect.minY + rect.height * 0.24, width: rect.width * 0.24, height: rect.height * 0.4))
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.18, y: rect.minY + rect.height * 0.36, width: rect.width * 0.56, height: rect.height * 0.36), cornerSize: CGSize(width: rect.height * 0.18, height: rect.height * 0.18))

        return path
    }
}
