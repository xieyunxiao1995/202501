import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct MomentRow: View {
    let moment: StoryMoment
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        let layout = typeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
            : AnyLayout(HStackLayout(spacing: 12))
        layout {
            Image(moment.sceneAsset)
                .resizable().scaledToFill()
                .frame(width: typeSize.isAccessibilitySize ? 180 : 94, height: typeSize.isAccessibilitySize ? 120 : 83)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 5) {
                Text(moment.title).font(.headline).foregroundStyle(TideColors.ink)
                Text(moment.recap).font(.caption).foregroundStyle(TideColors.muted)
                    .lineLimit(typeSize.isAccessibilitySize ? nil : 2)
                Text(moment.createdAt, style: .date).font(.caption2).foregroundStyle(TideColors.primary)
            }
            if !typeSize.isAccessibilitySize {
                Spacer(minLength: 2)
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(TideColors.muted)
                    .accessibilityHidden(true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .background(TideColors.card, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct StoryMomentDetailView: View {
    let moment: StoryMoment
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var confirmDelete = false
    @State private var showExporter = false
    @State private var pdfFile: PDFFileDocument?
    @State private var showPreview = false
    @State private var error: String?
    @State private var showMemoryApproval = false
    private var story: StoryDefinition? { ContentRepository.shared.story(id: moment.storyID) }
    private var chapter: ChapterDefinition? { story?.chapters.first { $0.id == moment.chapterID } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 19) {
                Color.clear
                    .frame(height: 220)
                    .overlay { Image(moment.sceneAsset).resizable().scaledToFill() }
                    .clipShape(RoundedRectangle(cornerRadius: 23))
                    .accessibilityHidden(true)
                Eyebrow(title: chapter.map { "\($0.actLabel) · Story moment" } ?? "Story moment")
                Text(moment.title).font(.largeTitle.bold())
                    .accessibilityIdentifier("momentTitle")
                if let chapter {
                    Text("\(chapter.actLabel) · Chapter \(chapter.number) · \(chapter.setting)")
                        .font(.caption).foregroundStyle(TideColors.bright)
                }
                Text(moment.createdAt, format: .dateTime.month(.wide).day().year())
                    .font(.subheadline).foregroundStyle(.secondary)
                Text("Your choice").font(.headline)
                Text(moment.decision).foregroundStyle(TideColors.primary)
                Text(moment.recap).font(.body).lineSpacing(5)
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(TideColors.card, in: RoundedRectangle(cornerRadius: 20))
                if ContentRepository.shared.character(id: moment.characterID) != nil {
                    Button("Keep a memory from this moment", systemImage: "pin") { showMemoryApproval = true }
                        .frame(minHeight: 44)
                }
                TidePrimaryButton(title: "Preview PDF", systemImage: "doc.richtext") { preparePDF(preview: true) }
                Button {
                    preparePDF(preview: false)
                } label: {
                    Label("Export this moment", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity, minHeight: 46)
                }
                .buttonStyle(.bordered)
            }
            .padding(18)
        }
        .tideBackground()
        .tideNavigationTitle("Story Moment")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Delete saved moment", systemImage: "trash", role: .destructive) { confirmDelete = true }
            }
        }
        .confirmationDialog("Delete this saved moment?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete moment", role: .destructive, action: deleteMoment)
            Button("Cancel", role: .cancel) { }
        } message: { Text("This removes the saved moment. Your chapter choice, journey progress and separately saved memories are kept.") }
        .fileExporter(isPresented: $showExporter, document: pdfFile, contentType: .pdf, defaultFilename: "Tideverse_Story_Moment") { result in
            if case .failure(let err) = result { error = err.localizedDescription }
        }
        .sheet(isPresented: $showMemoryApproval) {
            if let character = ContentRepository.shared.character(id: moment.characterID) {
                MemoryApprovalView(character: character, proposedText: moment.recap)
            }
        }
        .sheet(isPresented: $showPreview) {
            NavigationStack {
                if let pdfFile {
                    PDFPreviewView(data: pdfFile.data)
                        .tideNavigationTitle("PDF Preview")
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") { showPreview = false }
                            }
                        }
                }
            }
            .presentationDragIndicator(.visible)
        }
        .alert("Story Moment", isPresented: Binding(get: { error != nil }, set: { if !$0 { error = nil } })) {
            Button("OK") { error = nil }
        } message: { Text(error ?? "Unknown problem") }
    }

    private func deleteMoment() {
        context.delete(moment)
        do { try context.save(); dismiss() }
        catch { context.rollback(); self.error = error.localizedDescription }
    }

    private func preparePDF(preview: Bool) {
        pdfFile = PDFFileDocument(data: StoryPDFExporter.export(moment: moment))
        if preview { showPreview = true } else { showExporter = true }
    }
}
