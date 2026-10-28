import SwiftUI
import SwiftData

struct ProjectsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ProjectRecord.updatedAt, order: .reverse) private var projects: [ProjectRecord]
    @State private var search = ""
    @State private var showingNew = false
    @State private var saveError: String?

    private var filtered: [ProjectRecord] {
        projects.filter { search.isEmpty || $0.name.localizedStandardContains(search)
            || $0.location.localizedStandardContains(search) }
    }
    var body: some View {
        Group {
            if projects.isEmpty {
                VStack {
                    EmptyPanel(symbol: "square.stack.3d.up", heading: "Projects live here",
                               detail: "Track rooms, quantities and costs in one organized place.")
                    Button("Create Project") { showingNew = true }
                        .buttonStyle(PrimaryActionStyle()).padding(.horizontal, 30)
                }
            } else {
                List {
                    if filtered.isEmpty {
                        ContentUnavailableView.search(text: search)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    } else {
                        ForEach(filtered) { project in
                            NavigationLink { ProjectDetailView(project: project) } label: {
                                ProjectRow(project: project).padding(.vertical, 3)
                            }
                        }.onDelete(perform: delete)
                    }
                }.listStyle(.plain).searchable(text: $search, prompt: "Find a project")
            }
        }
        .background(AppTheme.paper)
        .navigationTitle("Projects")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar { ToolbarItem(placement: .topBarTrailing) {
            Button("Create project", systemImage: "plus") { showingNew = true }
        }}
        .sheet(isPresented: $showingNew) { ProjectEditorSheet() }
        .alert("Unable to delete project", item: $saveError) { _ in
            Button("OK", role: .cancel) { }
        } message: { message in
            Text(message)
        }
    }

    private func delete(at offsets: IndexSet) {
        let selected = offsets.map { filtered[$0] }
        let photos = selected.flatMap { $0.details.rooms.compactMap(\.photoFilename) }
        selected.forEach { context.delete($0) }
        do {
            try context.save()
            photos.forEach { RoomPhotoService.delete($0) }
        } catch {
            context.rollback()
            saveError = error.localizedDescription
        }
    }
}

struct ProjectRow: View {
    let project: ProjectRecord
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "house.fill").font(.title2).foregroundStyle(AppTheme.slate)
                .frame(width: 52, height: 52)
                .background(AppTheme.mist, in: RoundedRectangle(cornerRadius: 15))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 5) {
                Text(project.name).font(.headline).foregroundStyle(AppTheme.deep)
                Text(project.location.isEmpty ? "Home improvement project" : project.location)
                    .font(.caption).foregroundStyle(.secondary).lineLimit(1)
                if let details = try? project.readDetails() {
                    Text("\(details.rooms.count) \(details.rooms.count == 1 ? "room" : "rooms") · \(details.materials.count) \(details.materials.count == 1 ? "material" : "materials")")
                        .font(.caption).foregroundStyle(AppTheme.slate)
                } else {
                    Text("Project data unavailable").font(.caption).foregroundStyle(.red)
                }
            }
            Spacer(minLength: 5)
        }
        .accessibilityElement(children: .combine)
    }
}

struct ProjectEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    var project: ProjectRecord? = nil
    @State private var name = ""
    @State private var location = ""
    @State private var saveError: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Project details") {
                    TextField("Project name", text: $name)
                        .textInputAutocapitalization(.words)
                    TextField("Location (optional)", text: $location)
                }
                Section {
                    Text("Your project stays on this device. No account or internet connection is required.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle(project == nil ? "New Project" : "Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert("Unable to save project", item: $saveError) { _ in
                Button("OK", role: .cancel) { }
            } message: { message in
                Text(message)
            }
            .onAppear {
                if let project { name = project.name; location = project.location }
            }
        }.tint(AppTheme.slate)
    }
    private func save() {
        do {
            if let project {
                try project.requireAvailable(in: context)
                project.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                project.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
                project.updatedAt = .now
            } else {
                context.insert(ProjectRecord(name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                             location: location.trimmingCharacters(in: .whitespacesAndNewlines)))
            }
            try context.save()
            dismiss()
        } catch { context.rollback(); saveError = error.localizedDescription }
    }
}
