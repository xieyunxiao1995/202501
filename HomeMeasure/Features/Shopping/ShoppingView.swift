import SwiftUI
import SwiftData

struct ShoppingView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ProjectRecord.updatedAt, order: .reverse) private var projects: [ProjectRecord]
    @State private var showPurchased = true
    @State private var search = ""
    @State private var saveError: String?

    var body: some View {
        let content = ShoppingContent(projects: projects, showPurchased: showPurchased, search: search)
        Group {
            if content.totalCount == 0 && !content.hasUnreadableProject {
                EmptyPanel(symbol: "cart", heading: "Your shopping list is ready to grow",
                           detail: "Add materials inside any project to build a purchase list here.")
            } else if content.totalCount == 0 {
                EmptyPanel(symbol: "exclamationmark.triangle", heading: "Some project data is unavailable",
                           detail: "Open Projects to review affected projects or restore a backup.")
            } else {
                List {
                    Section {
                        ShoppingProgressHeader(total: content.totalCount,
                                               purchased: content.purchasedCount,
                                               showPurchased: $showPurchased)
                    }
                    if content.hasUnreadableProject {
                        Section {
                            Text("Some project data could not be read and is not shown here.")
                                .foregroundStyle(.red)
                        }
                    }
                    if content.sections.isEmpty {
                        Section {
                            ShoppingEmptyResults(search: search, showPurchased: showPurchased)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }
                    ForEach(content.sections) { section in
                        Section(section.project.name) {
                            ForEach(section.lines) { line in
                                ShoppingRow(line: line,
                                            currencyCode: section.currencyCode,
                                            onToggle: { toggle(line.material.id, in: section.project) })
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .searchable(text: $search, prompt: "Search materials")
            }
        }
        .navigationTitle("Shopping")
        .toolbarTitleDisplayMode(.inlineLarge)
        .alert("Unable to save purchase status", item: $saveError) { _ in
            Button("OK", role: .cancel) { }
        } message: { message in
            Text(message)
        }
    }

    private func toggle(_ materialID: UUID, in project: ProjectRecord) {
        do {
            try project.requireAvailable(in: context)
            var doc = try project.readDetails()
            guard let index = doc.materials.firstIndex(where: { $0.id == materialID }) else { return }
            doc.materials[index].purchased.toggle()
            try project.update(doc)
            try context.save()
        } catch {
            context.rollback()
            saveError = error.localizedDescription
        }
    }
}
