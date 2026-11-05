import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct DataManagementView: View {
    @Environment(\.modelContext) private var context
    @Query private var records: [StoredScene]
    @State private var importing = false
    @State private var exporting = false
    @State private var deleting = false
    @State private var file: ExportFileDocument?
    @State private var message: String?

    var body: some View {
        Form {
            Section("Local Backup") {
                Button { exportAll() } label: {
                    Label("Export All Scenes to JSON", systemImage: "square.and.arrow.up")
                }
                Button { importing = true } label: {
                    Label("Import JSON Project", systemImage: "square.and.arrow.down")
                }
                Text("Projects are exported as plain JSON so you can save and move them without an account.")
                    .font(.caption).foregroundStyle(AppTheme.textMuted)
            }
            Section("Delete Local Data") {
                LabeledContent("Scenes", value: "\(records.count)")
                Button("Delete All Scenes", role: .destructive) { deleting = true }
                    .disabled(records.isEmpty)
                Text("Deletion cannot be undone without an exported backup. Preferences are kept.")
                    .font(.caption).foregroundStyle(AppTheme.textMuted)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.navy.ignoresSafeArea())
        .navigationTitle("Backup & Data")
        .fileImporter(isPresented: $importing, allowedContentTypes: [.json]) { outcome in
            do {
                let url = try outcome.get()
                let scoped = url.startAccessingSecurityScopedResource()
                defer { if scoped { url.stopAccessingSecurityScopedResource() } }
                let imported = try ProjectBackupService.importScenes(Data(contentsOf: url))
                let count = try ProjectBackupService.insertImported(imported, into: context, existing: records)
                message = "Imported \(count) scene\(count == 1 ? "" : "s") to your device."
            } catch { message = error.localizedDescription }
        }
        .fileExporter(isPresented: $exporting, document: file, contentType: .json,
                      defaultFilename: "SunShadowPad-Backup") { outcome in
            if case .failure(let failure) = outcome { message = failure.localizedDescription }
        }
        .confirmationDialog("Delete every local scene?", isPresented: $deleting, titleVisibility: .visible) {
            Button("Delete Every Scene", role: .destructive) {
                for row in records { context.delete(row) }
                do { try context.save() } catch { message = error.localizedDescription }
            }
        } message: { Text("Export a JSON archive first if you want to recover these scenes.") }
        .alert("Project Data", isPresented: Binding(get: { message != nil },
                                                    set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: { Text(message ?? "") }
    }

    private func exportAll() {
        do {
            file = ExportFileDocument(bytes: try ProjectBackupService.exportAll(records))
            exporting = true
        } catch { message = error.localizedDescription }
    }
}
