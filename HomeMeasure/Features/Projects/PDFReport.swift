import Foundation

struct PDFReport: Identifiable {
    let id = UUID()
    let data: Data
    let filename: String
}
