import SwiftUI
import UniformTypeIdentifiers

struct PDFReportSheet: View {
    @Environment(\.dismiss) private var dismiss
    let report: PDFReport

    @State private var exporting = false
    @State private var exportError: String?

    var body: some View {
        NavigationStack {
            PDFPreviewView(data: report.data)
                .navigationTitle("Purchase Report")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save PDF") { exporting = true }
                    }
                }
                .fileExporter(isPresented: $exporting,
                              document: ExportFile(data: report.data),
                              contentType: .pdf,
                              defaultFilename: report.filename) { result in
                    if case .failure(let error) = result {
                        exportError = error.localizedDescription
                    }
                }
                .alert("Unable to save PDF", item: $exportError) { _ in
                    Button("OK", role: .cancel) { }
                } message: { message in
                    Text(message)
                }
        }
        .tint(AppTheme.slate)
    }
}
