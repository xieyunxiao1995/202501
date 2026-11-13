import SwiftUI
import SwiftData

struct MemoryLedgerView: View {
    let character: CharacterDefinition
    @Environment(\.modelContext) private var context
    @Query(sort: \MemoryRecord.createdAt, order: .reverse) private var allMemories: [MemoryRecord]
    @State private var isAdding = false
    @State private var draft = ""
    @State private var editing: MemoryRecord?
    @State private var error: String?

    private var records: [MemoryRecord] { allMemories.filter { $0.characterID == character.id } }
    private var includedIDs: Set<UUID> { Set(records.filter(\.isPinned).prefix(12).map(\.id)) }

    var body: some View {
        List {
            Section {
                Text("Only pinned notes you explicitly save may be shared with \(character.name) after you allow AI processing. Up to twelve recent pinned notes are used. Turn off the pin or delete a note at any time.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Section("Approved Memories") {
                if records.isEmpty {
                    ContentUnavailableView("No saved memories", systemImage: "brain", description: Text("Add a note you want this character to remember."))
                }
                ForEach(records) { record in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: record.isPinned ? "pin.fill" : "pin.slash")
                            .foregroundStyle(record.isPinned ? TideColors.primary : .secondary)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(record.note)
                            Text(record.isPinned ? (includedIDs.contains(record.id) ? "Selected for next AI context" : "Pinned · Outside the 12-note context limit") : "Excluded from AI context")
                                .font(.caption).foregroundStyle(.secondary)
                            if record.isPinned && record.note.utf16.count > ChatTextBudget.memory {
                                Text("Only the first part fits in AI context. Shorten this note to include it in full.")
                                    .font(.footnote).foregroundStyle(TideColors.bright)
                            }
                        }
                        Spacer()
                        Menu {
                            Button("Edit", systemImage: "pencil") {
                                draft = record.note; editing = record
                            }
                            Button(record.isPinned ? "Unpin" : "Pin", systemImage: "pin") {
                                record.isPinned.toggle(); persist()
                            }
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                context.delete(record); persist()
                            }
                        } label: {
                            Label("Memory options", systemImage: "ellipsis.circle").labelStyle(.iconOnly).frame(width: 44, height: 44)
                        }
                    }
                }
            }
            Section {
                Button {
                    draft = ""
                    isAdding = true
                } label: { Label("Add a Memory", systemImage: "plus.circle.fill") }
            }
        }
        .scrollContentBackground(.hidden)
        .tideBackground()
        .tideNavigationTitle("Memory Ledger")
        .sheet(isPresented: $isAdding) {
            MemoryEditor(title: "New Memory", note: $draft, onCancel: { isAdding = false }, onSave: {
                let note = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !note.isEmpty, note.utf16.count <= 500 else { return }
                context.insert(MemoryRecord(characterID: character.id, note: note))
                if persist() { isAdding = false }
            })
        }
        .sheet(item: $editing) { record in
            MemoryEditor(title: "Edit Memory", note: $draft, onCancel: { editing = nil }, onSave: {
                let note = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !note.isEmpty, note.utf16.count <= 500 else { return }
                record.note = note
                if persist() { editing = nil }
            })
        }
        .alert("Memory error", isPresented: Binding(get: { error != nil }, set: { if !$0 { error = nil } })) {
            Button("OK") { error = nil }
        } message: { Text(error ?? "Could not save") }
    }

    @discardableResult
    private func persist() -> Bool {
        do { try context.save(); return true }
        catch { context.rollback(); self.error = error.localizedDescription; return false }
    }
}

private struct MemoryEditor: View {
    let title: String
    @Binding var note: String
    let onCancel: () -> Void
    let onSave: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("What should this character remember?") {
                    TextEditor(text: $note)
                        .frame(minHeight: 150)
                    Text("\(note.utf16.count) / 500 characters").font(.caption).foregroundStyle(TideColors.muted)
                }
                Section {
                    Text("Avoid sensitive details about yourself or other people. This note stays on your device until you explicitly enable online AI chat.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .scrollContentBackground(.hidden)
            .tideBackground()
            .tideNavigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Cancel", action: onCancel) }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: onSave).disabled(note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || note.utf16.count > 500)
                }
            }
        }
    }
}
