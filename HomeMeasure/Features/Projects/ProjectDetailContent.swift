import SwiftUI

struct ProjectDetailContent: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let project: ProjectRecord
    let onAddRoom: () -> Void
    let onEditRoom: (RoomPlan) -> Void
    let onDeleteRoom: (RoomPlan) -> Void
    let onAddMaterial: () -> Void
    let onEditMaterial: (MaterialPlan) -> Void
    let onTogglePurchased: (UUID) -> Void
    let onDeleteMaterial: (MaterialPlan) -> Void
    let onEditBudget: () -> Void
    let onExportPDF: () -> Void

    var body: some View {
        let details = project.details
        let estimates = EstimationService.estimates(details)
        let budget = EstimationService.budget(details, estimates: estimates)
        let isTotalUnavailable = estimates.contains(where: \.quantityExceedsLimit)
        let countLayout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
            : AnyLayout(HStackLayout(spacing: 12))

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.location.isEmpty ? "HOME RENOVATION" : project.location.uppercased())
                        .font(.caption.weight(.bold))
                        .tracking(1.3)
                        .foregroundStyle(AppTheme.slate)
                    Text(project.name)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(AppTheme.deep)
                        .fixedSize(horizontal: false, vertical: true)
                    countLayout {
                        Label("\(details.rooms.count) \(details.rooms.count == 1 ? "room" : "rooms")", systemImage: "rectangle.3.group")
                        Label("\(details.materials.count) \(details.materials.count == 1 ? "material" : "materials")", systemImage: "square.stack")
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }

                ProjectBudgetCard(details: details,
                                  budget: budget,
                                  isTotalUnavailable: isTotalUnavailable,
                                  onEditBudget: onEditBudget)

                HStack {
                    SectionTitle(title: "Rooms")
                    Spacer()
                    Button("Add", systemImage: "plus", action: onAddRoom)
                }
                if details.rooms.isEmpty {
                    EmptyPanel(symbol: "rectangle.dashed", heading: "Measure your first room",
                               detail: "Add dimensions and openings to calculate usable surfaces.")
                        .background(.white, in: RoundedRectangle(cornerRadius: 20))
                }
                ForEach(details.rooms) { room in
                    RoomSummaryCard(room: room,
                                    onEdit: { onEditRoom(room) },
                                    onDelete: { onDeleteRoom(room) })
                }

                HStack {
                    SectionTitle(title: "Materials")
                    Spacer()
                    Button("Add", systemImage: "plus", action: onAddMaterial)
                        .disabled(details.rooms.isEmpty)
                }
                if details.materials.isEmpty {
                    EmptyPanel(symbol: "shippingbox", heading: "No materials yet",
                               detail: details.rooms.isEmpty
                               ? "Add a room first, then attach materials to it."
                               : "Choose a room, coverage and price to estimate a shopping quantity.")
                        .background(.white, in: RoundedRectangle(cornerRadius: 20))
                }
                ForEach(estimates) { item in
                    MaterialSummaryCard(estimate: item,
                                        currencyCode: details.currencyCode,
                                        onEdit: { onEditMaterial(item.material) },
                                        onTogglePurchased: { onTogglePurchased(item.material.id) },
                                        onDelete: { onDeleteMaterial(item.material) })
                }

                Button("Preview & Export PDF", systemImage: "doc.richtext", action: onExportPDF)
                    .buttonStyle(PrimaryActionStyle())
            }
            .padding(18)
        }
        .background(AppTheme.paper)
    }
}
