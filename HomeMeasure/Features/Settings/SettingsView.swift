import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Query private var projects: [ProjectRecord]
    @State private var backupFile: ExportFile?
    @State private var exporting = false
    @State private var importing = false
    @State private var showDeleteWarning = false
    @State private var showWelcomeTour = false
    @State private var message: String?

    var body: some View {
        List {
            Section {
                HStack(spacing: 13) {
                    Image(systemName: "house.fill")
                        .font(.title).foregroundStyle(AppTheme.mist)
                        .frame(width: 58, height: 58)
                        .background(AppTheme.deep, in: RoundedRectangle(cornerRadius: 17))
                    VStack(alignment: .leading, spacing: 4) {
                        Text("HomeMeasure").font(.title3.weight(.bold)).foregroundStyle(AppTheme.deep)
                        Text("Make every measure count.").font(.subheadline).foregroundStyle(.secondary)
                    }
                }.padding(.vertical, 8)
            }
            Section("About & support") {
                NavigationLink { AboutUsView() } label: { settingsRow("About Us", icon: "info.circle") }
                NavigationLink { TermsOfUseView() } label: { settingsRow("Terms of Use", icon: "doc.text") }
                NavigationLink { PrivacyPolicyView() } label: { settingsRow("Privacy Policy", icon: "hand.raised") }
                NavigationLink { HelpView() } label: { settingsRow("Help & FAQ", icon: "questionmark.circle") }
                NavigationLink { FeedbackView() } label: { settingsRow("Feedback & Suggestions", icon: "bubble.left") }
                Button { showWelcomeTour = true } label: {
                    HStack {
                        settingsRow("Welcome Tour", icon: "sparkles")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                            .accessibilityHidden(true)
                    }
                }
            }
            Section("Your local data") {
                Button { exportBackup() } label: {
                    settingsRow("Export Backup", icon: "square.and.arrow.up")
                }
                Button { importing = true } label: {
                    settingsRow("Import Backup", icon: "square.and.arrow.down")
                }
                Button(role: .destructive) { showDeleteWarning = true } label: {
                    settingsRow("Delete All Projects", icon: "trash", danger: true)
                }
            }
            Section {
                Text("HomeMeasure works without an account, subscription or network connection. Project details and room photos are saved on your device.")
                    .font(.footnote).foregroundStyle(.secondary)
                HStack { Spacer(); Text("Version \(version)").font(.caption).foregroundStyle(.tertiary); Spacer() }
                    .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Settings")
        .toolbarTitleDisplayMode(.inlineLarge)
        .scrollContentBackground(.hidden)
        .background(AppTheme.paper)
        .fileExporter(isPresented: $exporting, document: backupFile, contentType: .json,
                      defaultFilename: "HomeMeasure-Backup-\(Date.now.formatted(.iso8601.year().month().day().dateSeparator(.dash)))") { result in
            if case .failure(let error) = result { message = error.localizedDescription }
        }
        .fileImporter(isPresented: $importing, allowedContentTypes: [.json]) { result in
            do {
                let url = try result.get()
                let count = try BackupService.restore(from: url, into: context)
                message = "Imported \(count) project\(count == 1 ? "" : "s"). Imported projects are saved as separate copies."
            } catch { message = "Import failed: \(error.localizedDescription)" }
        }
        .confirmationDialog("Delete all local projects?", isPresented: $showDeleteWarning,
                            titleVisibility: .visible) {
            Button("Delete All Projects", role: .destructive) {
                for project in projects { context.delete(project) }
                do {
                    try context.save()
                    do {
                        try RoomPhotoService.removeAll()
                        message = "All projects and room photos were deleted from this device."
                    } catch {
                        message = "Projects were deleted, but some room photos could not be removed: \(error.localizedDescription)"
                    }
                } catch {
                    context.rollback()
                    message = "Deletion failed: \(error.localizedDescription)"
                }
            }
        } message: {
            Text("This removes the project library and its shopping lists. Export a backup first if needed. This cannot be undone.")
        }
        .fullScreenCover(isPresented: $showWelcomeTour) {
            WelcomeTourView { showWelcomeTour = false }
        }
        .alert("HomeMeasure", item: $message) { _ in
            Button("OK", role: .cancel) { }
        } message: { text in
            Text(text)
        }
    }

    private var version: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0" }
    private func settingsRow(_ title: String, icon: String, danger: Bool = false) -> some View {
        Label {
            Text(title).foregroundStyle(danger ? Color.red : AppTheme.deep)
        } icon: {
            Image(systemName: icon).foregroundStyle(danger ? Color.red : AppTheme.slate)
                .frame(width: 28)
        }
    }
    private func exportBackup() {
        do { backupFile = try BackupService.makeBackup(projects); exporting = true }
        catch { message = error.localizedDescription }
    }
}
