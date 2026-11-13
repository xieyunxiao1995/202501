import Foundation
import SwiftUI
import PDFKit
import UniformTypeIdentifiers
import UIKit
import CoreText

struct PDFFileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.pdf] }
    var data: Data

    init(data: Data) { self.data = data }

    init(configuration: ReadConfiguration) throws {
        guard let value = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        data = value
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

struct PDFPreviewView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.backgroundColor = .systemBackground
        view.document = PDFDocument(data: data)
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if uiView.document?.dataRepresentation() != data {
            uiView.document = PDFDocument(data: data)
        }
    }
}

struct StoryPDFExporter {
    static func export(moment: StoryMoment) -> Data {
        let bounds = CGRect(x: 0, y: 0, width: 612, height: 792)
        let content = NSMutableAttributedString()
        let blue = UIColor(red: 0.08, green: 0.40, blue: 0.82, alpha: 1)
        func append(_ text: String, font: UIFont, color: UIColor, spacing: CGFloat) {
            let paragraph = NSMutableParagraphStyle()
            paragraph.paragraphSpacing = spacing
            paragraph.lineSpacing = 4
            content.append(NSAttributedString(string: text + "\n", attributes: [
                .font: font, .foregroundColor: color, .paragraphStyle: paragraph
            ]))
        }
        append("TIDEVERSE  /  STORY MOMENT", font: .systemFont(ofSize: 11, weight: .bold), color: blue, spacing: 19)
        append(moment.title, font: .systemFont(ofSize: 26, weight: .bold),
               color: UIColor(red: 0.08, green: 0.20, blue: 0.34, alpha: 1), spacing: 13)
        append(moment.createdAt.formatted(date: .abbreviated, time: .omitted),
               font: .systemFont(ofSize: 12), color: .darkGray, spacing: 22)
        append("YOUR CHOICE", font: .systemFont(ofSize: 11, weight: .bold), color: blue, spacing: 7)
        append(moment.decision, font: .systemFont(ofSize: 16, weight: .medium), color: .black, spacing: 24)
        append("WHAT HAPPENED", font: .systemFont(ofSize: 11, weight: .bold), color: blue, spacing: 8)
        append(moment.recap, font: .systemFont(ofSize: 15), color: .darkGray, spacing: 0)

        let framesetter = CTFramesetterCreateWithAttributedString(content)
        let renderer = UIGraphicsPDFRenderer(bounds: bounds)
        return renderer.pdfData { context in
            var offset = 0
            var page = 0
            while offset < content.length {
                context.beginPage()
                page += 1
                blue.setFill()
                UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width, height: 13)).fill()
                // Core Text uses a bottom-left origin. Keep text clear of the footer.
                let graphics = context.cgContext
                graphics.saveGState()
                graphics.textMatrix = .identity
                graphics.translateBy(x: 0, y: bounds.height)
                graphics.scaleBy(x: 1, y: -1)
                let path = CGPath(rect: CGRect(x: 48, y: 80, width: 516, height: 660), transform: nil)
                let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: offset, length: 0), path, nil)
                CTFrameDraw(frame, graphics)
                let visible = CTFrameGetVisibleStringRange(frame)
                graphics.restoreGState()
                let footer = "Tideverse · Interactive fiction · Page \(page)"
                footer.draw(at: CGPoint(x: 48, y: 738), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.darkGray
                ])
                guard visible.length > 0 else { break }
                offset += visible.length
            }
        }
    }
}
