import SwiftUI
import UIKit
import SwiftData
import UniformTypeIdentifiers
import Combine

struct SimulatorView: View {
    @EnvironmentObject private var workspace: WorkspaceState
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Query(sort: \StoredScene.updatedAt, order: .reverse) private var records: [StoredScene]
    @AppStorage("measurementUnit") private var measurementUnit = "m"
    @AppStorage("use24HourClock") private var use24HourClock = true
    @AppStorage("simulatorViewMode") private var viewMode: SceneViewMode = .threeD
    @State private var playing = false
    @State private var speed = 1
    @State private var timeStep = 15
    @State private var showSunTrail = false
    @State private var exporting = false
    @State private var file: ExportFileDocument?
    @State private var exportType: UTType = .png
    @State private var exportName = "SunShadowPad-Shadow"
    @State private var error: String?
    @State private var editorRecord: StoredScene?
    private let timer = Timer.publish(every: 0.16, on: .main, in: .common).autoconnect()

    private var current: StoredScene? {
        records.first { $0.id == workspace.selectedSceneID && !$0.isArchived }
            ?? records.first { !$0.isArchived }
    }

    var body: some View {
        Group {
            if let record = current {
                simulator(record: record)
            } else {
                ContentUnavailableView {
                    Label("No Active Scene", systemImage: "sun.max")
                } description: {
                    Text("Create a scene in the Scenes tab to see its shadows here.")
                } actions: {
                    Button("Go to Scenes") { workspace.selectedTab = .scenes }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Shadow Simulator")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppTheme.navy.ignoresSafeArea())
        .onReceive(timer) { _ in
            guard playing else { return }
            let next = workspace.minuteOfDay + Double(5 * speed)
            workspace.minuteOfDay = next >= 1440 ? 0 : next
        }
        .onDisappear { playing = false }
        .sheet(item: $editorRecord) { record in
            SceneEditorView(record: record)
        }
        .fileExporter(isPresented: $exporting, document: file, contentType: exportType,
                      defaultFilename: exportName) { result in
            if case .failure(let failure) = result { error = failure.localizedDescription }
        }
        .alert("Export Failed", isPresented: Binding(get: { error != nil },
                                                     set: { if !$0 { error = nil } })) {
            Button("OK") { error = nil }
        } message: { Text(error ?? "") }
    }

    private func simulator(record: StoredScene) -> some View {
        let scene = record.document
        let moment = TimeService.localInstant(on: workspace.inspectionDate,
                                             minutes: Int(workspace.minuteOfDay), in: scene.timeZoneID)
        let sun = SolarPositionEngine.position(at: moment, latitude: scene.latitude,
                                               longitude: scene.longitude, timeZoneID: scene.timeZoneID)
        let events = SolarPositionEngine.events(on: workspace.inspectionDate, in: scene)
        let firstObject = scene.activeElements.first
        let shadowLength = firstObject.flatMap { object in
            sun.isAboveHorizon ? object.height / tan(sun.elevation * .pi / 180) : nil
        }
        let blocked = scene.targets.first.map { target in
            ShadowGeometryEngine.blockers(at: Point2(x: target.x, y: target.y), scene: scene, sun: sun)
        } ?? []
        return ScrollView {
            VStack(spacing: 14) {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 10) {
                        sceneSelector
                        editSceneButton(record)
                        Spacer()
                        datePicker(scene)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            sceneSelector
                            editSceneButton(record)
                        }
                        datePicker(scene)
                    }
                }
                .padding(.horizontal, 6)

                Group {
                    if viewMode == .threeD {
                        Scene3DView(scene: scene, moment: moment)
                    } else {
                        SceneCanvasView(scene: scene, moment: moment)
                    }
                }
                .frame(height: 350)
                .overlay(alignment: .topLeading) {
                    Label(sun.isAboveHorizon ? "DIRECT SUN" : "NIGHT",
                          systemImage: sun.isAboveHorizon ? "sun.max.fill" : "moon.stars")
                        .font(.caption2.bold())
                        .padding(8)
                        .background(AppTheme.panel.opacity(0.9), in: Capsule())
                        .padding(10)
                }
                .overlay(alignment: .bottomTrailing) {
                    SceneViewModeToggle(mode: $viewMode)
                        .padding(10)
                }
                .overlay(alignment: .bottomLeading) {
                    if viewMode == .threeD && !dynamicTypeSize.isAccessibilitySize {
                        Label("Drag to orbit · Pinch to zoom", systemImage: "hand.draw")
                            .font(.caption2.weight(.semibold))
                            .padding(.horizontal, 9)
                            .padding(.vertical, 6)
                            .background(AppTheme.navy.opacity(0.78), in: Capsule())
                            .padding(10)
                    }
                }
                Surface {
                    ViewThatFits(in: .horizontal) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Time of Day").font(.headline)
                            Spacer()
                            clockLabel(moment, scene: scene)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Time of Day").font(.headline)
                            clockLabel(moment, scene: scene)
                        }
                    }
                    Slider(value: $workspace.minuteOfDay, in: 0...1439, step: 5)
                        .tint(AppTheme.yellow).accessibilityLabel("Local time of day")
                    HStack {
                        Text("00:00")
                        Spacer()
                        Text("12:00")
                        Spacer()
                        Text("23:59")
                    }.font(.caption2).foregroundStyle(AppTheme.textMuted)
                    Divider().overlay(AppTheme.elevated)
                    Group {
                        if dynamicTypeSize.isAccessibilitySize {
                            VStack(spacing: 10) {
                                HStack(spacing: 10) {
                                    Button { workspace.minuteOfDay = max(0, workspace.minuteOfDay - Double(timeStep)) } label: {
                                        Image(systemName: "gobackward")
                                    }
                                    .accessibilityLabel("Back \(timeStep) minutes")
                                    Button { playing.toggle() } label: {
                                        Image(systemName: playing ? "pause.fill" : "play.fill")
                                    }
                                    .accessibilityLabel(playing ? "Pause" : "Play")
                                    .buttonStyle(.borderedProminent)
                                    Button { workspace.minuteOfDay = min(1439, workspace.minuteOfDay + Double(timeStep)) } label: {
                                        Image(systemName: "goforward")
                                    }
                                    .accessibilityLabel("Forward \(timeStep) minutes")
                                }
                                HStack {
                                    timeStepMenu
                                    Spacer()
                                    speedMenu
                                }
                            }
                        } else {
                            HStack(spacing: 8) {
                                Button { workspace.minuteOfDay = max(0, workspace.minuteOfDay - Double(timeStep)) } label: {
                                    Image(systemName: "gobackward")
                                }
                                .accessibilityLabel("Back \(timeStep) minutes")
                                Button { playing.toggle() } label: {
                                    Label(playing ? "Pause" : "Play", systemImage: playing ? "pause.fill" : "play.fill")
                                }.buttonStyle(.borderedProminent)
                                Button { workspace.minuteOfDay = min(1439, workspace.minuteOfDay + Double(timeStep)) } label: {
                                    Image(systemName: "goforward")
                                }
                                .accessibilityLabel("Forward \(timeStep) minutes")
                                timeStepMenu
                                Spacer()
                                speedMenu
                            }
                        }
                    }.buttonStyle(.bordered)
                    Divider().overlay(AppTheme.elevated)
                    Group {
                        if dynamicTypeSize.isAccessibilitySize {
                            VStack(spacing: 8) {
                                eventButton("Sunrise", time: events.sunrise, scene: scene)
                                eventButton("Solar Noon", time: events.solarNoon, scene: scene)
                                eventButton("Sunset", time: events.sunset, scene: scene)
                            }
                        } else {
                            HStack(spacing: 8) {
                                eventButton("Sunrise", time: events.sunrise, scene: scene)
                                eventButton("Solar Noon", time: events.solarNoon, scene: scene)
                                eventButton("Sunset", time: events.sunset, scene: scene)
                            }
                        }
                    }.font(.caption)
                }
                Group {
                    if dynamicTypeSize.isAccessibilitySize {
                        VStack(spacing: 8) {
                            MetricView(label: "Elevation", value: String(format: "%.1f°", sun.elevation), symbol: "sun.max")
                            MetricView(label: "Azimuth", value: String(format: "%.1f°", sun.azimuth), symbol: "location.north")
                            MetricView(label: "\(firstObject?.name ?? "Shadow") length",
                                       value: lengthLabel(shadowLength), symbol: "ruler")
                        }
                    } else {
                        HStack(spacing: 8) {
                            MetricView(label: "Elevation", value: String(format: "%.1f°", sun.elevation), symbol: "sun.max")
                            MetricView(label: "Azimuth", value: String(format: "%.1f°", sun.azimuth), symbol: "location.north")
                            MetricView(label: "\(firstObject?.name ?? "Shadow") length",
                                       value: lengthLabel(shadowLength), symbol: "ruler")
                        }
                    }
                }
                if let target = scene.targets.first {
                    Surface {
                        HStack {
                            Image(systemName: blocked.isEmpty && sun.isAboveHorizon ? "sun.max.fill" : "cloud.fill")
                                .foregroundStyle(AppTheme.yellow)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(target.name).font(.headline)
                                Text(!sun.isAboveHorizon ? "No direct sun — below horizon" :
                                    blocked.isEmpty ? "Direct sun reaches the observation point" :
                                    "Blocked by \(blocked.joined(separator: ", "))")
                                    .font(.caption).foregroundStyle(AppTheme.textMuted)
                            }
                            Spacer()
                        }
                    }
                }
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 10) {
                        saveImageButton(scene: scene, at: moment)
                        exportReportButton(scene: scene)
                    }
                    VStack(spacing: 10) {
                        saveImageButton(scene: scene, at: moment)
                        exportReportButton(scene: scene)
                    }
                }.frame(maxWidth: .infinity)
                Text("Geometric simulation of direct sunlight on level ground. Not a weather or survey forecast.")
                    .font(.caption2).foregroundStyle(AppTheme.textMuted)
                    .multilineTextAlignment(.center)
            }.padding(14)
        }
    }

    private var sceneSelector: some View {
        SceneSelector(records: records, selection: workspace.selectedSceneID) {
            workspace.selectedSceneID = $0
        }
    }

    private func editSceneButton(_ record: StoredScene) -> some View {
        Button { editorRecord = record } label: {
            Image(systemName: "pencil")
                .font(.subheadline.bold())
                .foregroundStyle(AppTheme.yellow)
                .frame(width: 34, height: 34)
                .background(AppTheme.panel, in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Edit \(record.name)")
    }

    private func datePicker(_ scene: SceneDocument) -> some View {
        DatePicker("Date", selection: $workspace.inspectionDate, displayedComponents: .date)
            .labelsHidden()
            .environment(\.timeZone, scene.timeZone)
    }

    private func clockLabel(_ moment: Date, scene: SceneDocument) -> some View {
        Text(TimeService.clock(moment, timeZoneID: scene.timeZoneID, is24Hour: use24HourClock))
            .font(.system(.title, design: .rounded, weight: .semibold))
            .foregroundStyle(AppTheme.yellow)
            .minimumScaleFactor(0.7).lineLimit(1)
    }

    private var timeStepMenu: some View {
        Menu {
            Picker("Time Step", selection: $timeStep) {
                ForEach([5, 15, 30], id: \.self) { minutes in
                    Text("\(minutes) min").tag(minutes)
                }
            }
        } label: { Text("\(timeStep) min").font(.caption.bold()) }
    }

    private var speedMenu: some View {
        Menu {
            ForEach([1, 3, 6], id: \.self) { multiplier in
                Button("\(multiplier)×") { speed = multiplier }
            }
        } label: { Text("\(speed)×").font(.caption.bold()) }
    }

    private func saveImageButton(scene: SceneDocument, at moment: Date) -> some View {
        Button { exportPNG(scene: scene, at: moment) } label: {
            Label("Save Image", systemImage: "photo").frame(maxWidth: .infinity)
        }.buttonStyle(.bordered)
    }

    private func exportReportButton(scene: SceneDocument) -> some View {
        Button { exportPDF(scene: scene) } label: {
            Label("Export Report", systemImage: "doc.richtext").frame(maxWidth: .infinity)
        }.buttonStyle(.borderedProminent)
    }

    private func eventButton(_ title: String, time: Date?, scene: SceneDocument) -> some View {
        Button(title) {
            if let time {
                let cal = TimeService.calendar(scene.timeZoneID)
                let components = cal.dateComponents([.hour, .minute], from: time)
                workspace.minuteOfDay = Double((components.hour ?? 12) * 60 + (components.minute ?? 0))
            }
        }
        .disabled(time == nil)
        .buttonStyle(.bordered)
    }

    private func lengthLabel(_ meters: Double?) -> String {
        guard let meters, meters.isFinite else { return "—" }
        let factor = measurementUnit == "ft" ? 3.28084 : 1
        let suffix = measurementUnit == "ft" ? "ft" : "m"
        return String(format: "%.1f %@", meters * factor, suffix)
    }

    @MainActor
    private func exportPNG(scene: SceneDocument, at moment: Date) {
        let renderer = ImageRenderer(content:
            SceneCanvasView(scene: scene, moment: moment, showsGrid: false)
                .frame(width: 1000, height: 800))
        renderer.scale = 1.5
        guard let data = renderer.uiImage?.pngData() else { error = "Unable to render the current scene."; return }
        file = ExportFileDocument(bytes: data)
        exportType = .png
        exportName = "\(scene.name)-Shadow"
        exporting = true
    }

    @MainActor
    private func exportPDF(scene: SceneDocument) {
        let result = ExposureAnalysisEngine.calculate(scene: scene, day: workspace.inspectionDate)
        file = ExportFileDocument(bytes: ReportExportService.pdf(scene: scene, result: result))
        exportType = .pdf
        exportName = "\(scene.name)-Planning-Report"
        exporting = true
    }
}

struct SceneSelector: View {
    let records: [StoredScene]
    let selection: UUID?
    let onSelect: (UUID) -> Void
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    var body: some View {
        Menu {
            ForEach(records.filter { !$0.isArchived }) { record in
                Button(record.name) { onSelect(record.id) }
            }
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "square.stack.3d.up")
                Text(records.first(where: { $0.id == selection })?.name
                     ?? records.first(where: { !$0.isArchived })?.name ?? "Choose Scene")
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 3 : 1)
                Image(systemName: "chevron.down").font(.caption2)
            }.font(.subheadline.bold())
        }
    }
}
