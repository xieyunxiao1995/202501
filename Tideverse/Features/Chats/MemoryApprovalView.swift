import SwiftUI
import SwiftData

struct MemoryApprovalView: View {
    let character: CharacterDefinition
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var note: String
    @State private var isPinned = true
    @State private var errorMessage: String?

    init(character: CharacterDefinition, proposedText: String) {
        self.character = character
        _note = State(initialValue: ChatTextBudget.prefix(proposedText, limit: ChatTextBudget.memory))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Review this memory") {
                    TextField("Write what you want to keep", text: $note, axis: .vertical).lineLimit(5...12)
                    Text("\(note.utf16.count) / 500 characters").font(.caption).foregroundStyle(TideColors.muted)
                    Toggle("Pin for future AI conversations", isOn: $isPinned)
                }
                Section {
                    Text("Edit the selected text before saving. Only pinned notes for \(character.name) may be included in future requests after you enable AI processing. AI text can be inaccurate; saving it does not make it part of the authored story.")
                        .font(.footnote).foregroundStyle(TideColors.muted)
                }
            }
            .scrollContentBackground(.hidden).tideBackground()
            .tideNavigationTitle("Save a Memory")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save).disabled(note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || note.utf16.count > 500)
                }
            }
            .alert("Could not save memory", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) { } message: {
                Text(errorMessage ?? "Please try again.")
            }
        }
    }

    private func save() {
        let memory = MemoryRecord(characterID: character.id, note: note.trimmingCharacters(in: .whitespacesAndNewlines), isPinned: isPinned)
        context.insert(memory)
        do { try context.save(); dismiss() }
        catch { context.delete(memory); errorMessage = error.localizedDescription }
    }
}
