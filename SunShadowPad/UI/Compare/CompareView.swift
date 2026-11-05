import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct CompareView: View {
    let base: SceneDocument
    let records: [StoredScene]
    let inspectionDate: Date
    let selectedTargetID: UUID?

    @Environment(\.modelContext) private var context
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var selectedAlternativeID: UUID?
    @State private var comparison: ScenarioDifference?
    @State private var loading = false
    @State private var document: ExportFileDocument?
    @State private var exporting = false
    @State private var error: String?

    private var candidates: [StoredScene] {
        records.filter { $0.id != base.id && !$0.isArchived &&
            ScenarioComparisonService.sameSite(base, $0.document) }
    }
    private var alternative: StoredScene? {
        candidates.first(where: { $0.id == selectedAlternativeID }) ?? candidates.first
    }
    private var alternativeSelection: Binding<UUID?> {
        Binding(get: { alternative?.id }, set: { selectedAlternativeID = $0 })
    }
    private var computeKey: String {
        "\(base.id)|\(alternative?.id.uuidString ?? "none")|\(alternative?.updatedAt.timeIntervalSince1970 ?? 0)|\(inspectionDate.timeIntervalSince1970)|\(selectedTargetID?.uuidString ?? "none")"
    }

    var body: some View {
        VStack(spacing: 12) {
            if candidates.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "square.on.square")
                        .font(.largeTitle)
                        .foregroundStyle(AppTheme.textMuted)
                    Text("No Matching Layout")
                        .font(.headline)
                    Text("Duplicate this scene, change the copy, then compare both versions here.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textMuted)
                        .multilineTextAlignment(.center)
                    Button("Duplicate Current Layout") { duplicateAsAlternative() }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
            } else if let alternative {
                Surface {
                    Picker("Alternative Layout", selection: alternativeSelection) {
                        ForEach(candidates) { item in
                            Text(item.name).tag(Optional(item.id))
                        }
                    }
                    .pickerStyle(.menu)
                    Text("Both layouts share location, dimensions, north direction and time zone.")
                        .font(.caption).foregroundStyle(AppTheme.textMuted)
                }
                if dynamicTypeSize.isAccessibilitySize {
                    VStack(alignment: .leading, spacing: 10) {
                        canvasColumn("Original", document: base)
                        canvasColumn("Alternative", document: alternative.document)
                    }
                } else {
                    HStack(spacing: 9) {
                        canvasColumn("Original", document: base)
                        canvasColumn("Alternative", document: alternative.document)
                    }
                }
                if loading { ProgressView("Comparing layouts …") }
                if let comparison {
                    HStack(spacing: 8) {
                        MetricView(label: "Original", value: String(format: "%.2f h", comparison.baseHours), symbol: "sun.max")
                        MetricView(label: "Alternative", value: String(format: "%.2f h", comparison.changedHours), symbol: "sun.max.fill")
                        MetricView(label: "Change", value: String(format: "%+.2f h", comparison.difference),
                                   symbol: "arrow.left.arrow.right")
                    }
                    Surface {
                        Text("Exposure Difference Map").font(.headline)
                        ChangeHeatmapView(base: base, a: comparison.a, b: comparison.b)
                            .frame(height: 230)
                        Text("Green gains direct sunlight • Amber loses direct sunlight")
                            .font(.caption2).foregroundStyle(AppTheme.textMuted)
                    }
                    Button {
                        document = ExportFileDocument(bytes: ReportExportService.pdf(
                            scene: base, result: comparison.a,
                            comparison: (scene: alternative.document, result: comparison.b)))
                        exporting = true
                    } label: { Label("Export Comparison PDF", systemImage: "doc.richtext") }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .onChange(of: base.id) { _, _ in
            selectedAlternativeID = candidates.first?.id
            comparison = nil
        }
        .task(id: computeKey) {
            guard let alternative else { comparison = nil; return }
            loading = true
            let a = base, b = alternative.document, day = inspectionDate, target = selectedTargetID
            let computed = await Task.detached(priority: .userInitiated) {
                ScenarioComparisonService.compare(a, b, day: day, targetID: target)
            }.value
            guard !Task.isCancelled else { return }
            comparison = computed
            loading = false
        }
        .fileExporter(isPresented: $exporting, document: document,
                      contentType: .pdf, defaultFilename: "SunShadowPad-Layout-Comparison") { result in
            if case .failure(let failure) = result { error = failure.localizedDescription }
        }
        .alert("Could Not Export", isPresented: Binding(get: { error != nil },
                                                         set: { if !$0 { error = nil } })) {
            Button("OK") { error = nil }
        } message: { Text(error ?? "") }
    }

    private func canvasColumn(_ title: String, document: SceneDocument) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline.bold())
            SceneCanvasView(scene: document,
                            moment: TimeService.localInstant(on: inspectionDate,
                                                             minutes: 720, in: base.timeZoneID),
                            showsGrid: false)
                .frame(height: 195)
        }
    }

    private func duplicateAsAlternative() {
        let copy = base.copyAs("\(base.name) — Alternative")
        let record = StoredScene(document: copy)
        context.insert(record)
        try? context.save()
        selectedAlternativeID = record.id
    }
}

struct ChangeHeatmapView: View {
    let base: SceneDocument
    let a: ExposureResult
    let b: ExposureResult

    var body: some View {
        Canvas { ctx, size in
            let margin: CGFloat = 10
            let factor = min((size.width - margin * 2) / CGFloat(base.width),
                             (size.height - margin * 2) / CGFloat(base.height))
            let offsetX = size.width / 2 - CGFloat(base.width) * factor / 2
            let offsetY = size.height / 2 - CGFloat(base.height) * factor / 2
            for index in a.heat.indices where index < b.heat.count {
                let cell = a.heat[index]
                let delta = b.heat[index].sunnyHours - cell.sunnyHours
                let strength = min(0.95, max(0.07, abs(delta) / 3.0))
                let color = abs(delta) < 0.08 ? AppTheme.panel :
                    (delta > 0 ? AppTheme.grass : AppTheme.yellow)
                let rect = CGRect(x: offsetX + CGFloat(cell.x) * factor,
                                  y: offsetY + CGFloat(cell.y) * factor,
                                  width: CGFloat(cell.width) * factor + 0.2,
                                  height: CGFloat(cell.height) * factor + 0.2)
                ctx.fill(Path(rect), with: .color(color.opacity(strength)))
            }
        }
        .background(AppTheme.navy, in: RoundedRectangle(cornerRadius: 12))
    }
}
