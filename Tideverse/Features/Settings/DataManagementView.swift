import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct DataManagementView: View {
    @Environment(\.modelContext) private var context
    @Query private var messages: [ChatRecord]
    @Query private var memories: [MemoryRecord]
    @Query private var moments: [StoryMoment]
    @Query private var progresses: [JourneyProgress]
    @AppStorage("tideverse.cloudConsent") private var cloudConsent = false
    @AppStorage("tideverse.feedbackDraft") private var feedbackDraft = ""
    @State private var exportFile: JSONFileDocument?
    @State private var exportFilename = "Tideverse_My_Data"
    @State private var showExporter = false
    @State private var showImporter = false
    @State private var showDeleteConfirmation = false
    @State private var showDeleteChats = false
    @State private var showDeleteMemories = false
    @State private var showImportConfirmation = false
    @State private var incomingData: Data?
    @State private var importSummary = ""
    @State private var notice: String?
    @State private var includePhotos = true

    var body: some View {
        Form {
            Section("On This Device") {
                LabeledContent("Chat messages", value: String(messages.count))
                LabeledContent("Approved memory notes", value: String(memories.count))
                LabeledContent("Story Moments", value: String(moments.count))
                LabeledContent("Story progress records", value: String(progresses.count))
            }
            .listRowBackground(TideColors.card)
            Section("Transfer Your Data") {
                Toggle("Include Attached Photos", isOn: $includePhotos)
                Text("Turn this off for a smaller text-only archive. Photos will stay on this device but will not be included in that backup. Archives must be 35 MB or smaller to restore.")
                    .font(.footnote).foregroundStyle(TideColors.muted)
                Button { exportData() } label: {
                    Label("Export JSON Archive", systemImage: "square.and.arrow.up")
                }
                Button { showImporter = true } label: {
                    Label("Import JSON Archive", systemImage: "square.and.arrow.down")
                }
                Text("JSON archives can contain private messages, attached photos and memory notes. Save them only to a location you trust. Import merges new records and restores newer progress.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .listRowBackground(TideColors.card)
            Section("Erase Data") {
                Button("Delete Conversations", role: .destructive) { showDeleteChats = true }
                Button("Delete Memories", role: .destructive) { showDeleteMemories = true }
                Button(role: .destructive) { showDeleteConfirmation = true } label: {
                    Label("Delete All Local Data", systemImage: "trash")
                }
                Text("Deletes local conversations, attached photos, memories, story progress and moments. Does not erase data already sent to an external AI provider.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .listRowBackground(TideColors.card)
        }
        .scrollContentBackground(.hidden)
        .tideBackground()
        .tideNavigationTitle("Data Management")
        .fileExporter(isPresented: $showExporter, document: exportFile, contentType: .json, defaultFilename: exportFilename) { result in
            if case .failure(let error) = result { notice = error.localizedDescription }
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.json], allowsMultipleSelection: false) { result in
            do {
                guard let url = try result.get().first else { return }
                let granted = url.startAccessingSecurityScopedResource()
                defer { if granted { url.stopAccessingSecurityScopedResource() } }
                let size = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize
                guard let size, size <= BackupService.maximumArchiveSize else { throw BackupError.archiveTooLarge }
                let data = try Data(contentsOf: url)
                guard data.count <= BackupService.maximumArchiveSize else { throw BackupError.archiveTooLarge }
                let archive = try BackupService.previewArchive(data)
                importSummary = """
                Exported \(archive.exportedAt.formatted(date: .abbreviated, time: .omitted)).

                Messages: \(archive.messages.count.formatted())
                Memory notes: \(archive.memories.count.formatted())
                Story Moments: \(archive.moments.count.formatted())
                Journeys: \(archive.progresses.count.formatted())

                New records are merged. Newer archive progress can replace your current chapter and choices. Existing conversations and memories are kept.
                """
                incomingData = data
                showImportConfirmation = true
            } catch { notice = error.localizedDescription }
        }
        .confirmationDialog("Import This Archive?", isPresented: $showImportConfirmation, titleVisibility: .visible) {
            Button("Import & Merge") { importData() }
            Button("Cancel", role: .cancel) { incomingData = nil }
        } message: {
            Text(importSummary)
        }
        .confirmationDialog("Delete All Conversations?", isPresented: $showDeleteChats, titleVisibility: .visible) {
            Button("Delete Conversations", role: .destructive) {
                do { try BackupService.deleteChats(from: context); notice = "Conversations and their photo attachments were deleted." }
                catch { notice = error.localizedDescription }
            }
            Button("Cancel", role: .cancel) { }
        } message: { Text("This deletes all local conversations and attached photos.") }
        .confirmationDialog("Delete All Memories?", isPresented: $showDeleteMemories, titleVisibility: .visible) {
            Button("Delete Memories", role: .destructive) {
                do { try BackupService.deleteMemories(from: context); notice = "Your memory notes were deleted." }
                catch { notice = error.localizedDescription }
            }
            Button("Cancel", role: .cancel) { }
        } message: { Text("This deletes all saved memory notes for every character.") }
        .confirmationDialog("Delete All Local Data?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete All Data", role: .destructive) { deleteData() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone unless you previously exported a JSON archive.")
        }
        .alert("Data Management", isPresented: Binding(get: { notice != nil }, set: { if !$0 { notice = nil } })) {
            Button("OK") { notice = nil }
        } message: { Text(notice ?? "") }
    }

    private func exportData() {
        do {
            exportFile = JSONFileDocument(data: try BackupService.export(from: context, includePhotos: includePhotos))
            exportFilename = "Tideverse_\(Date.now.ISO8601Format().replacingOccurrences(of: ":", with: "-"))"
            showExporter = true
        } catch { notice = error.localizedDescription }
    }

    private func importData() {
        guard let incomingData else { return }
        do { notice = try BackupService.importArchive(incomingData, into: context) }
        catch { notice = error.localizedDescription }
        self.incomingData = nil
    }

    private func deleteData() {
        do {
            try BackupService.deleteAll(from: context)
            ConsentService.clear()
            cloudConsent = false
            feedbackDraft = ""
            UserDefaults.standard.removeObject(forKey: "tideverse.savedCharacters")
            UserDefaults.standard.removeObject(forKey: "tideverse.hiddenCharacters")
            notice = "Your local Tideverse data has been deleted."
        } catch { notice = error.localizedDescription }
    }
}
