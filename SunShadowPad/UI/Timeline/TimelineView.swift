import SwiftUI
import SwiftData
import Charts
import UniformTypeIdentifiers

struct MonthlyExposure: Identifiable {
    let month: Int
    let hours: Double
    var id: Int { month }
}

private struct SeasonExposure: Identifiable {
    let name: String
    let date: Date
    let hours: Double
    var id: String { name }
}

struct TimelineView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case day = "Day"
        case heatmap = "Heatmap"
        case seasons = "Seasons"
        case compare = "Compare"
        var id: String { rawValue }
    }

    private static let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    @EnvironmentObject private var workspace: WorkspaceState
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Query(sort: \StoredScene.updatedAt, order: .reverse) private var records: [StoredScene]
    @AppStorage("use24HourClock") private var use24HourClock = true
    @State private var mode: Mode = .day
    @State private var targetID: UUID?
    @State private var stepMinutes = 10
    @State private var columns = 18
    @State private var result: ExposureResult?
    @State private var selectedCell: HeatCell?
    @State private var compareDate: Date?
    @State private var compareResult: ExposureResult?
    @State private var compareBusy = false
    @State private var seasonal: [SeasonExposure] = []
    @State private var seasonalBusy = false
    @State private var busy = false
    @State private var exporting = false
    @State private var file: ExportFileDocument?
    @State private var exportType: UTType = .pdf
    @State private var exportName = "SunShadowPad-Exposure"
    @State private var error: String?

    init() {
        #if DEBUG
        if let raw = UserDefaults.standard.string(forKey: "timelineMode"),
           let start = Mode(rawValue: raw) {
            _mode = State(initialValue: start)
        }
        #endif
    }

    private var selected: StoredScene? {
        records.first(where: { $0.id == workspace.selectedSceneID && !$0.isArchived })
            ?? records.first(where: { !$0.isArchived })
    }
    private var refreshID: String {
        "\(selected?.id.uuidString ?? "none")|\(selected?.updatedAt.timeIntervalSince1970 ?? 0)|\(workspace.forceRefresh)|\(workspace.inspectionDate.timeIntervalSince1970)|\(targetID?.uuidString ?? "none")|\(stepMinutes)|\(columns)"
    }
    private var compareRefreshID: String {
        "\(selected?.id.uuidString ?? "none")|\(selected?.updatedAt.timeIntervalSince1970 ?? 0)|\(workspace.forceRefresh)|\(compareDate?.timeIntervalSince1970 ?? 0)|\(targetID?.uuidString ?? "none")|\(stepMinutes)|\(columns)"
    }
    private var seasonalRefreshID: String {
        guard let selected else { return "none" }
        let year = TimeService.calendar(selected.document.timeZoneID)
            .component(.year, from: workspace.inspectionDate)
        return "\(selected.id.uuidString)|\(selected.updatedAt.timeIntervalSince1970)|\(workspace.forceRefresh)|\(targetID?.uuidString ?? "none")|\(year)"
    }

    var body: some View {
        Group {
            if let selected {
                timeline(scene: selected.document)
            } else {
                ContentUnavailableView {
                    Label("No Active Scene", systemImage: "chart.bar")
                } description: {
                    Text("Start with a project in Scenes.")
                } actions: {
                    Button("Go to Scenes") { workspace.selectedTab = .scenes }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Sunlight Timeline")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppTheme.navy.ignoresSafeArea())
        .onAppear {
            #if DEBUG
            let days = UserDefaults.standard.integer(forKey: "compareDays")
            if days != 0, compareDate == nil, let selected {
                compareDate = TimeService.calendar(selected.document.timeZoneID)
                    .date(byAdding: .day, value: days, to: workspace.inspectionDate)
            }
            #endif
        }
        .task(id: refreshID) {
            guard let selected else { result = nil; return }
            busy = true
            let doc = selected.document
            let day = workspace.inspectionDate
            let point = targetID
            let interval = stepMinutes
            let cols = columns
            let computed = await Task.detached(priority: .userInitiated) {
                ExposureAnalysisEngine.calculate(scene: doc, day: day, targetID: point,
                                                 stepMinutes: interval, columns: cols)
            }.value
            guard !Task.isCancelled else { return }
            result = computed
            busy = false
        }
        .task(id: compareRefreshID) {
            guard let selected, let compareDate else {
                compareResult = nil
                compareBusy = false
                return
            }
            compareBusy = true
            let doc = selected.document
            let point = targetID
            let interval = stepMinutes
            let cols = columns
            let computed = await Task.detached(priority: .userInitiated) {
                ExposureAnalysisEngine.calculate(scene: doc, day: compareDate, targetID: point,
                                                 stepMinutes: interval, columns: cols)
            }.value
            guard !Task.isCancelled else { return }
            compareResult = computed
            compareBusy = false
        }
        .onChange(of: workspace.selectedSceneID) { _, _ in
            targetID = nil
            result = nil
            selectedCell = nil
            compareDate = nil
            compareResult = nil
            seasonal = []
        }
        .onChange(of: refreshID) { _, _ in selectedCell = nil }
        .onChange(of: compareRefreshID) { _, _ in
            if compareDate != nil { compareResult = nil }
        }
        .onChange(of: seasonalRefreshID) { _, _ in seasonal = [] }
        .fileExporter(isPresented: $exporting, document: file, contentType: exportType,
                      defaultFilename: exportName) { response in
            if case .failure(let failure) = response { error = failure.localizedDescription }
        }
        .alert("Export Failed", isPresented: Binding(get: { error != nil },
                                                     set: { if !$0 { error = nil } })) {
            Button("OK") { error = nil }
        } message: { Text(error ?? "") }
    }

    private func timeline(scene: SceneDocument) -> some View {
        ScrollView {
            VStack(spacing: 14) {
                ViewThatFits(in: .horizontal) {
                    HStack {
                        SceneSelector(records: records, selection: workspace.selectedSceneID) {
                            workspace.selectedSceneID = $0
                        }
                        Spacer()
                        DatePicker("Date", selection: $workspace.inspectionDate, displayedComponents: .date)
                            .labelsHidden().environment(\.timeZone, scene.timeZone)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        SceneSelector(records: records, selection: workspace.selectedSceneID) {
                            workspace.selectedSceneID = $0
                        }
                        DatePicker("Date", selection: $workspace.inspectionDate, displayedComponents: .date)
                            .labelsHidden()
                            .accessibilityLabel("Analysis date")
                            .environment(\.timeZone, scene.timeZone)
                    }
                }
                .padding(.horizontal, 6)
                HStack(spacing: 10) {
                    if dynamicTypeSize.isAccessibilitySize {
                        Menu {
                            ForEach(Mode.allCases) { option in
                                Button(option.rawValue) { mode = option }
                            }
                        } label: {
                            ViewThatFits(in: .horizontal) {
                                HStack(spacing: 7) {
                                    Text("Analysis").foregroundStyle(AppTheme.textMuted)
                                    Text(mode.rawValue).foregroundStyle(AppTheme.yellow).bold()
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.caption2).foregroundStyle(AppTheme.textMuted)
                                }
                                HStack(spacing: 7) {
                                    Text(mode.rawValue).foregroundStyle(AppTheme.yellow).bold()
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.caption2).foregroundStyle(AppTheme.textMuted)
                                }
                            }
                            .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("Analysis mode, \(mode.rawValue)")
                    } else {
                        Picker("Analysis", selection: $mode) {
                            ForEach(Mode.allCases) { mode in Text(mode.rawValue).tag(mode) }
                        }.pickerStyle(.segmented)
                    }
                    Menu {
                        Picker("Time Step", selection: $stepMinutes) {
                            ForEach([5, 10, 15, 30], id: \.self) { n in Text("\(n) min").tag(n) }
                        }
                        Picker("Grid Density", selection: $columns) {
                            ForEach([12, 18, 24, 30], id: \.self) { n in Text("\(n) columns").tag(n) }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                    .accessibilityLabel("Sampling precision")
                }
                if mode == .compare {
                    CompareView(base: scene, records: records,
                                inspectionDate: workspace.inspectionDate, selectedTargetID: targetID)
                } else {
                    if !scene.targets.isEmpty {
                        HStack {
                            Menu {
                                Button("Site Average") { targetID = nil }
                                ForEach(scene.targets) { target in
                                    Button(target.name) { targetID = target.id }
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Text(targetLabel(scene: scene))
                                        .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                                        .multilineTextAlignment(.leading)
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.caption2)
                                }
                                .font(.subheadline.bold())
                                .foregroundStyle(AppTheme.yellow)
                            }
                            .accessibilityLabel("Observation target")
                            Spacer()
                        }
                    }
                    if busy { ProgressView("Calculating sunlight …").frame(maxWidth: .infinity).padding() }
                    if let result {
                        switch mode {
                        case .day: dayContents(scene: scene, result: result)
                        case .heatmap: heatmapContents(scene: scene, result: result)
                        case .seasons: seasonsContents(scene: scene)
                        case .compare: EmptyView()
                        }
                        if mode != .seasons {
                            Button { export(result: result, scene: scene) } label: {
                                Label("Export Planning Report", systemImage: "square.and.arrow.up")
                            }.buttonStyle(.borderedProminent).padding(.top, 4)
                        }
                    }
                }
                Text("Values describe theoretical direct sunlight under the obstacles you model, not measured weather or plant health.")
                    .font(.caption2).foregroundStyle(AppTheme.textMuted)
                    .multilineTextAlignment(.center)
            }.padding(14)
        }
    }

    private func dayContents(scene: SceneDocument, result: ExposureResult) -> some View {
        let target = result.targets.first(where: { $0.targetID == targetID })
        let siteMean = result.heat.map(\.sunnyHours).reduce(0, +) / Double(max(1, result.heat.count))
        return VStack(spacing: 13) {
            Surface {
                ViewThatFits(in: .horizontal) {
                    HStack {
                        Text(target?.name ?? "Site-Wide Average").font(.headline)
                        Spacer()
                        summaryValue(target: target, siteMean: siteMean)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(target?.name ?? "Site-Wide Average").font(.headline)
                        summaryValue(target: target, siteMean: siteMean)
                    }
                }
                if let target {
                    ViewThatFits(in: .horizontal) {
                        HStack {
                            targetStatus(target)
                            Spacer()
                            Text(String(format: "Goal %.1f h", target.targetHours))
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            targetStatus(target)
                            Text(String(format: "Goal %.1f h", target.targetHours))
                        }
                    }.font(.subheadline)
                }
            }
            Surface {
                Text("Direct Sun Exposure").font(.headline)
                HStack(spacing: 0) {
                    ForEach(result.samples) { sample in
                        Rectangle()
                            .fill(sample.isDay ? (sample.sunny ? AppTheme.yellow : AppTheme.shadow) : AppTheme.navy)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 45).clipShape(RoundedRectangle(cornerRadius: 6))
                HStack {
                    Text("00:00"); Spacer(); Text("12:00"); Spacer(); Text("24:00")
                }.font(.caption2).foregroundStyle(AppTheme.textMuted)
                HStack(spacing: 16) {
                    Label("Sun", systemImage: "circle.fill").foregroundStyle(AppTheme.yellow)
                    Label("Blocked", systemImage: "circle.fill").foregroundStyle(AppTheme.textMuted)
                    Spacer()
                }.font(.caption2)
            }
            let events = result.events
            Group {
                if dynamicTypeSize.isAccessibilitySize {
                    VStack(spacing: 8) {
                        eventMetrics(scene: scene, events: events)
                    }
                } else {
                    HStack(spacing: 9) {
                        eventMetrics(scene: scene, events: events)
                    }
                }
            }
            if let target {
                Group {
                    if dynamicTypeSize.isAccessibilitySize {
                        VStack(spacing: 8) {
                            exposureMetrics(target: target)
                        }
                    } else {
                        HStack(spacing: 8) {
                            exposureMetrics(target: target)
                        }
                    }
                }
                Surface {
                    ViewThatFits(in: .horizontal) {
                        HStack {
                            exposureTime(label: "First Exposure", value: target.firstSun, scene: scene, alignment: .leading)
                            Spacer()
                            exposureTime(label: "Last Exposure", value: target.lastSun, scene: scene, alignment: .trailing)
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            exposureTime(label: "First Exposure", value: target.firstSun, scene: scene, alignment: .leading)
                            exposureTime(label: "Last Exposure", value: target.lastSun, scene: scene, alignment: .leading)
                        }
                    }.font(.subheadline)
                }
            }
            dateComparison(scene: scene, result: result)
        }
    }

    private func summaryValue(target: TargetExposure?, siteMean: Double) -> some View {
        Text(String(format: "%.2f h", target?.sunnyHours ?? siteMean))
            .font(.title2.bold()).foregroundStyle(AppTheme.yellow)
    }

    private func targetStatus(_ target: TargetExposure) -> some View {
        Label(target.meetsTarget ? "Meets Target" : "Below Target",
              systemImage: target.meetsTarget ? "checkmark.circle.fill" : "exclamationmark.circle")
            .foregroundStyle(target.meetsTarget ? AppTheme.grass : .orange)
    }

    @ViewBuilder
    private func eventMetrics(scene: SceneDocument, events: SunEventTimes) -> some View {
        MetricView(label: "Sunrise",
                   value: TimeService.clock(events.sunrise, timeZoneID: scene.timeZoneID,
                                            is24Hour: use24HourClock), symbol: "sunrise")
        MetricView(label: "Solar Noon",
                   value: TimeService.clock(events.solarNoon, timeZoneID: scene.timeZoneID,
                                            is24Hour: use24HourClock), symbol: "sun.max")
        MetricView(label: "Sunset",
                   value: TimeService.clock(events.sunset, timeZoneID: scene.timeZoneID,
                                            is24Hour: use24HourClock), symbol: "sunset")
    }

    @ViewBuilder
    private func exposureMetrics(target: TargetExposure) -> some View {
        MetricView(label: "Blocked", value: String(format: "%.2f h", target.blockedHours),
                   symbol: "cloud")
        MetricView(label: "Longest Sunny", value: String(format: "%.2f h", target.longestSunnyHours),
                   symbol: "clock")
    }

    private func exposureTime(label: String, value: Date?, scene: SceneDocument,
                              alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(label).font(.caption).foregroundStyle(AppTheme.textMuted)
            Text(TimeService.clock(value, timeZoneID: scene.timeZoneID, is24Hour: use24HourClock))
        }
    }

    private func dateComparison(scene: SceneDocument, result: ExposureResult) -> some View {
        Surface {
            VStack(alignment: .leading, spacing: 12) {
                Toggle(isOn: Binding(
                    get: { compareDate != nil },
                    set: { isOn in
                        if isOn {
                            compareDate = TimeService.calendar(scene.timeZoneID)
                                .date(byAdding: .day, value: 90, to: workspace.inspectionDate)
                        } else {
                            compareDate = nil
                            compareResult = nil
                        }
                    })) {
                    Label("Compare Dates", systemImage: "calendar.badge.clock").font(.headline)
                }
                if let compareDate {
                    let secondDate = Binding(
                        get: { compareDate },
                        set: { self.compareDate = $0 })
                    if dynamicTypeSize.isAccessibilitySize {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Second Date")
                            DatePicker("", selection: secondDate, displayedComponents: .date)
                                .labelsHidden()
                                .environment(\.timeZone, scene.timeZone)
                        }
                    } else {
                        DatePicker("Second Date", selection: secondDate, displayedComponents: .date)
                            .environment(\.timeZone, scene.timeZone)
                    }
                    if let compareResult {
                        let first = hours(in: result)
                        let second = hours(in: compareResult)
                        VStack(spacing: 12) {
                            comparisonRow(date: workspace.inspectionDate, hours: first,
                                          result: result, scene: scene)
                            comparisonRow(date: compareDate, hours: second,
                                          result: compareResult, scene: scene)
                            HStack {
                                Text("Difference").font(.subheadline)
                                Spacer()
                                Text(String(format: "%+.2f h", second - first))
                                    .font(.subheadline.bold())
                                    .foregroundStyle(second >= first ? AppTheme.grass : .orange)
                            }
                        }
                    } else if compareBusy {
                        ProgressView().frame(maxWidth: .infinity).padding(.vertical, 6)
                    }
                }
            }
        }
    }

    private func comparisonRow(date: Date, hours: Double,
                               result: ExposureResult, scene: SceneDocument) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(TimeService.dayLabel(date, timeZoneID: scene.timeZoneID))
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer(minLength: 8)
                Text(String(format: "%.2f h", hours))
                    .font(.subheadline.bold()).foregroundStyle(AppTheme.yellow)
            }
            HStack(spacing: 0) {
                ForEach(result.samples) { sample in
                    Rectangle()
                        .fill(sample.isDay ? (sample.sunny ? AppTheme.yellow : AppTheme.shadow) : AppTheme.navy)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 16).clipShape(RoundedRectangle(cornerRadius: 3))
        }
    }

    private func targetLabel(scene: SceneDocument) -> String {
        scene.targets.first(where: { $0.id == targetID })?.name ?? "Site Average"
    }

    private func hours(in result: ExposureResult) -> Double {
        if let target = result.targets.first(where: { $0.targetID == targetID }) {
            return target.sunnyHours
        }
        return result.heat.map(\.sunnyHours).reduce(0, +) / Double(max(1, result.heat.count))
    }

    private func heatmapContents(scene: SceneDocument, result: ExposureResult) -> some View {
        VStack(spacing: 12) {
            SceneCanvasView(scene: scene, moment: workspace.inspectionDate,
                            heatmap: result, showsGrid: false,
                            onSelectHeatCell: { selectedCell = $0 },
                            highlightedHeatCellID: selectedCell?.id)
                .frame(height: 360)
            Surface {
                HStack {
                    Label("Less Sun", systemImage: "moon.stars").font(.caption)
                    Spacer()
                    LinearGradient(colors: [.init(red: 0.24, green: 0.31, blue: 0.49), AppTheme.yellow],
                                   startPoint: .leading, endPoint: .trailing)
                        .frame(width: 130, height: 10).clipShape(Capsule())
                    Spacer()
                    Text("More Sun").font(.caption)
                }
                Text(String(format: "Peak theoretical daylight: %.1f h. \(result.cols) × \(result.rows) sample cells.",
                            result.maxSunHours))
                    .font(.caption).foregroundStyle(AppTheme.textMuted)
                Divider()
                if let cell = selectedCell {
                    HStack {
                        Label("Cell \(cell.col + 1) × \(cell.row + 1)", systemImage: "scope")
                            .font(.subheadline.bold())
                        Spacer()
                        Text(String(format: "%.2f h direct sun", cell.sunnyHours))
                            .font(.subheadline.bold()).foregroundStyle(AppTheme.yellow)
                    }
                    Text(String(format: "Centre %.1f m, %.1f m from the top-left corner.",
                                cell.x + cell.width / 2, cell.y + cell.height / 2))
                        .font(.caption2).foregroundStyle(AppTheme.textMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button("Clear Selected Cell") { selectedCell = nil }
                        .font(.caption)
                } else {
                    Text("Tap a grid cell to read its theoretical direct-sun hours.")
                        .font(.caption).foregroundStyle(AppTheme.textMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            if !result.targets.isEmpty {
                ForEach(result.targets) { t in
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(t.name).font(.subheadline.bold())
                            Text(String(format: "Target: %.1f h", t.targetHours))
                                .font(.caption).foregroundStyle(AppTheme.textMuted)
                        }
                        Spacer()
                        Text(String(format: "%.2f h", t.sunnyHours))
                            .font(.headline).foregroundStyle(t.meetsTarget ? AppTheme.grass : .orange)
                    }.padding(12).background(AppTheme.panel, in: RoundedRectangle(cornerRadius: 14))
                }
            }
        }
    }

    private func seasonsContents(scene: SceneDocument) -> some View {
        let year = TimeService.calendar(scene.timeZoneID).component(.year, from: workspace.inspectionDate)
        let target = scene.targets.first(where: { $0.id == targetID })
        let monthly = ExposureAnalysisEngine.monthlyHours(scene: scene, year: year, target: target)
            .map { MonthlyExposure(month: $0.month, hours: $0.hours) }
        return VStack(spacing: 12) {
            Surface {
                Text("Representative Day • 15th of Each Month").font(.headline)
                Text(verbatim: "\(year) · \(target?.name ?? "Center of Scene")")
                    .font(.caption).foregroundStyle(AppTheme.textMuted)
                Chart(monthly) { sample in
                    BarMark(x: .value("Month", Self.monthNames[sample.month - 1]),
                            y: .value("Hours", sample.hours))
                        .foregroundStyle(AppTheme.yellow.gradient)
                }
                .chartYAxisLabel("Direct sun (h)")
                .frame(height: 235)
                Text("Monthly results represent the selected date only; they are not monthly averages.")
                    .font(.caption2).foregroundStyle(AppTheme.textMuted)
            }
            let peaks = monthly.sorted { $0.hours > $1.hours }
            HStack(spacing: 8) {
                MetricView(label: "Brightest 15th",
                           value: "\(Self.monthNames[(peaks.first?.month ?? 1) - 1]) 15",
                           symbol: "sun.max")
                MetricView(label: "Darkest 15th",
                           value: "\(Self.monthNames[(peaks.last?.month ?? 12) - 1]) 15",
                           symbol: "cloud")
            }
            seasonalComparison(scene: scene)
        }
    }

    private func seasonalComparison(scene: SceneDocument) -> some View {
        Surface {
            VStack(alignment: .leading, spacing: 12) {
                Text("Seasonal Comparison").font(.headline)
                if seasonalBusy && seasonal.isEmpty {
                    ProgressView().frame(maxWidth: .infinity).padding(.vertical, 6)
                } else {
                    let peak = max(1, seasonal.map(\.hours).max() ?? 1)
                    ForEach(seasonal) { sample in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(sample.name).font(.subheadline.bold())
                                Spacer(minLength: 8)
                                Text(String(format: "%.2f h", sample.hours))
                                    .font(.subheadline.bold()).foregroundStyle(AppTheme.yellow)
                            }
                            ProgressView(value: sample.hours, total: peak)
                                .tint(AppTheme.yellow)
                            Text(TimeService.dayLabel(sample.date, timeZoneID: scene.timeZoneID))
                                .font(.caption2).foregroundStyle(AppTheme.textMuted)
                        }
                    }
                    Text("Markers fall near each equinox and solstice; each result describes that single day.")
                        .font(.caption2).foregroundStyle(AppTheme.textMuted)
                }
            }
        }
        .task(id: seasonalRefreshID) {
            seasonalBusy = true
            let doc = scene
            let point = targetID
            let year = TimeService.calendar(scene.timeZoneID)
                .component(.year, from: workspace.inspectionDate)
            let samples = await Task.detached(priority: .userInitiated) {
                ExposureAnalysisEngine.seasonalHours(
                    scene: doc, year: year,
                    target: doc.targets.first(where: { $0.id == point }))
            }.value
            guard !Task.isCancelled else { return }
            seasonal = samples.map { SeasonExposure(name: $0.name, date: $0.date, hours: $0.hours) }
            seasonalBusy = false
        }
    }

    @MainActor
    private func export(result: ExposureResult, scene: SceneDocument) {
        file = ExportFileDocument(bytes: ReportExportService.pdf(scene: scene, result: result))
        exportType = .pdf
        exportName = "\(scene.name)-Sunlight-Analysis"
        exporting = true
    }
}
