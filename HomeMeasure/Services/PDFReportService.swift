import Foundation
import UIKit
import CoreGraphics
import PDFKit
import SwiftUI

struct PDFPreviewView: UIViewRepresentable {
    let data: Data
    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.backgroundColor = UIColor.systemGroupedBackground
        view.document = PDFDocument(data: data)
        return view
    }
    func updateUIView(_ view: PDFView, context: Context) {
        if view.document?.dataRepresentation() != data { view.document = PDFDocument(data: data) }
    }
}

enum PDFReportService {
    private static let page = CGRect(x: 0, y: 0, width: 595, height: 842) // A4 at 72 dpi
    private static let ink = UIColor(red: 23/255, green: 59/255, blue: 75/255, alpha: 1)
    private static let accent = UIColor(red: 70/255, green: 126/255, blue: 148/255, alpha: 1)
    private static let gray = UIColor.darkGray
    private static let margin: CGFloat = 46

    static func makeReport(project: ProjectRecord) throws -> Data {
        let doc = try project.readDetails()
        let budget = EstimationService.budget(doc)
        let rows = EstimationService.estimates(doc)
        let renderer = UIGraphicsPDFRenderer(bounds: page)
        return renderer.pdfData { context in
            var y: CGFloat = 0
            var pageNumber = 0
            func newPage() {
                context.beginPage()
                pageNumber += 1
                y = 52
                draw("HOMEMEASURE", at: .init(x: margin, y: y), font: .boldSystemFont(ofSize: 12), color: accent)
                draw("RENOVATION PURCHASE REPORT", at: .init(x: margin, y: y + 19),
                     font: .boldSystemFont(ofSize: 20), color: ink)
                line(y: y + 55)
                y += 75
                draw("Page \(pageNumber)", at: .init(x: page.width - margin - 75, y: page.height - 34),
                     font: .systemFont(ofSize: 10), color: gray)
            }
            func ensure(_ requiredHeight: CGFloat) { if y + requiredHeight > page.height - 65 { newPage() } }
            func write(_ text: String, font: UIFont, color: UIColor, indent: CGFloat = 0) {
                let width = page.width - margin * 2 - indent
                var current = ""
                func emit() {
                    ensure(font.lineHeight + 3)
                    draw(current, at: .init(x: margin + indent, y: y), font: font, color: color)
                    y += font.lineHeight + 3
                }
                for character in text {
                    let candidate = current + String(character)
                    if character == "\n" {
                        emit()
                        current = ""
                    } else if !current.isEmpty && (candidate as NSString).size(withAttributes: [.font: font]).width > width {
                        emit()
                        current = String(character)
                    } else {
                        current = candidate
                    }
                }
                if !current.isEmpty { emit() }
            }
            func section(_ title: String) {
                ensure(45)
                y += 8
                write(title, font: .boldSystemFont(ofSize: 11), color: accent)
                y += 4
            }
            newPage()
            write("Project", font: .systemFont(ofSize: 10), color: gray)
            write(project.name, font: .boldSystemFont(ofSize: 17), color: ink)
            if !project.location.isEmpty {
                write("Location: \(project.location)", font: .systemFont(ofSize: 11), color: gray)
            }
            write("Prepared: \(Date.now.formatted(date: .abbreviated, time: .omitted))",
                  font: .systemFont(ofSize: 11), color: gray)

            section("ROOM MEASUREMENTS")
            if doc.rooms.isEmpty { write("No rooms have been added.", font: .systemFont(ofSize: 11), color: gray) }
            for room in doc.rooms {
                ensure(45)
                let m = EstimationService.room(room)
                write(room.name, font: .boldSystemFont(ofSize: 11), color: ink)
                write("Floor: \(EstimationService.measure(m.floor))  ·  Net walls: \(EstimationService.measure(m.wallNet))  ·  Baseboard: \(EstimationService.measure(m.baseboardLength, unit: "m"))",
                      font: .systemFont(ofSize: 10), color: gray, indent: 10)
                y += 6
            }

            section("MATERIALS & QUANTITIES")
            if rows.isEmpty { write("Add materials to populate the purchase list.", font: .systemFont(ofSize: 11), color: gray) }
            for item in rows {
                ensure(65)
                write(item.material.name, font: .boldSystemFont(ofSize: 11), color: ink)
                write("Room: \(item.roomName)  ·  \(item.material.surface.rawValue)  ·  \(item.material.wastePercent.formatted())% waste  ·  \(item.material.purchased ? "Purchased" : "To buy")",
                      font: .systemFont(ofSize: 10), color: gray, indent: 10)
                if item.quantityExceedsLimit {
                    write("Quantity and cost unavailable. Check coverage or set an override.",
                          font: .systemFont(ofSize: 10), color: .red, indent: 10)
                } else {
                    write("Quantity: \(item.packs) \(item.material.packUnit)  ·  Unit price: \(EstimationService.money(EstimationService.decimal(item.material.unitPrice), code: doc.currencyCode))  ·  Total: \(EstimationService.money(item.cost, code: doc.currencyCode))",
                          font: .systemFont(ofSize: 10), color: ink, indent: 10)
                }
                y += 8
            }
            section("COSTS")
            if rows.contains(where: \.quantityExceedsLimit) {
                write("Total unavailable until all material quantities can be calculated.", font: .systemFont(ofSize: 11), color: .red)
            } else {
                write("Materials subtotal: \(EstimationService.money(budget.subtotal, code: doc.currencyCode))", font: .systemFont(ofSize: 11), color: gray)
                write("Estimated tax (\(doc.taxPercent.formatted())%): \(EstimationService.money(budget.tax, code: doc.currencyCode))", font: .systemFont(ofSize: 11), color: gray)
                write("Delivery / shipping: \(EstimationService.money(budget.shipping, code: doc.currencyCode))", font: .systemFont(ofSize: 11), color: gray)
                write("ESTIMATED TOTAL: \(EstimationService.money(budget.total, code: doc.currencyCode))", font: .boldSystemFont(ofSize: 13), color: ink)
            }
            if !doc.notes.isEmpty {
                section("PROJECT NOTES")
                write(doc.notes, font: .systemFont(ofSize: 10), color: gray)
            }
            y += 10
            write("Estimates are planning guides, not supplier quotations. Verify measurements, coverage, and local taxes.",
                  font: .systemFont(ofSize: 9), color: gray)
        }
    }

    private static func draw(_ text: String, at point: CGPoint, font: UIFont, color: UIColor) {
        (text as NSString).draw(at: point, withAttributes: [
            .font: font, .foregroundColor: color
        ])
    }
    private static func line(y: CGFloat) {
        accent.withAlphaComponent(0.2).setStroke()
        let path = UIBezierPath(); path.move(to: .init(x: margin, y: y))
        path.addLine(to: .init(x: page.width - margin, y: y)); path.lineWidth = 0.7
        path.stroke()
    }
}
