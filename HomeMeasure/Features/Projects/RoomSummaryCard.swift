import SwiftUI

struct RoomSummaryCard: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let room: RoomPlan
    let onEdit: () -> Void
    let onDelete: () -> Void

    private var dimensions: String {
        "\(EstimationService.measure(room.length, unit: "m")) × \(EstimationService.measure(room.width, unit: "m")) × \(EstimationService.measure(room.height, unit: "m"))"
    }

    var body: some View {
        let measures = EstimationService.room(room)
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
            : AnyLayout(HStackLayout(spacing: 12))

        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                photo
                VStack(alignment: .leading, spacing: 3) {
                    Text(room.name)
                        .font(.headline)
                        .foregroundStyle(AppTheme.deep)
                    Text(dimensions)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                Menu {
                    Button("Edit", systemImage: "pencil", action: onEdit)
                    Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
                } label: {
                    Label("Room options", systemImage: "ellipsis.circle")
                }
                .labelStyle(.iconOnly)
                .accessibilityLabel("Options for \(room.name)")
            }
            layout {
                MeasureValue(label: "Floor", value: EstimationService.measure(measures.floor))
                MeasureValue(label: "Net walls", value: EstimationService.measure(measures.wallNet))
                MeasureValue(label: "Baseboard", value: EstimationService.measure(measures.baseboardLength, unit: "m"))
            }
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 19))
    }

    @ViewBuilder
    private var photo: some View {
        if let image = RoomPhotoService.image(room.photoFilename) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 58, height: 58)
                .clipped()
                .clipShape(.rect(cornerRadius: 12))
                .accessibilityHidden(true)
        } else {
            Image(systemName: "square.dashed")
                .font(.title2)
                .frame(width: 58, height: 58)
                .foregroundStyle(AppTheme.slate)
                .background(AppTheme.mist, in: RoundedRectangle(cornerRadius: 12))
                .accessibilityHidden(true)
        }
    }
}
