import SwiftUI

struct LocationAttachmentRowView: View {
    let attachedPlace: Place?
    let onRemoveTapped: () -> Void
    let onTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location (optional)")
                .font(.headline)
                .foregroundStyle(.primary)

            if let attachedPlace {
                VStack(alignment: .leading, spacing: 14) {
                    Button(action: onTapped) {
                        HStack(spacing: 14) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.appNeutral)
                                .frame(width: 48, height: 48)
                                .overlay {
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundStyle(Color.appPrimary)
                                }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(attachedPlace.name)
                                    .foregroundStyle(.primary)
                                    .font(.headline)

                                Text(attachedPlace.address)
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundStyle(.tertiary)
                        }
                        .padding(16)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)

                    Button("Remove Location", role: .destructive, action: onRemoveTapped)
                }
            } else {
                Button(action: onTapped) {
                    HStack {
                        Label("Add location", systemImage: "plus.circle")
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .padding(18)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 18))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
