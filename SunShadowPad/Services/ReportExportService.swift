import Foundation
import UIKit

/// Printable PDF uses the same geometry and analysis results as the interactive UI.
@MainActor
enum ReportExportService {
    static func pdf(scene: SceneDocument, result: ExposureResult,
                    comparison: (scene: SceneDocument, result: ExposureResult)? = nil) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [kCGPDFContextTitle as String: "\(scene.name) | Sunlight Planning",
                               kCGPDFContextCreator as String: "SunShadowPad"]
        let page = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: page, format: format)
        return renderer.pdfData { pdf in
            pdf.beginPage()
            drawPageBase(page: page, section: "SITE STUDY")
            text("\(scene.name)", x: 40, y: 87, size: 25, bold: true)
            text("\(TimeService.dayLabel(result.day, timeZoneID: scene.timeZoneID))  •  \(scene.timeZoneID)",
                 x: 40, y: 124, size: 11, color: .darkGray)
            text(String(format: "Location: %.4f°, %.4f°    |    Site: %.1f × %.1f m    |    North: %.0f°",
                        scene.latitude, scene.longitude, scene.width, scene.height, scene.northDegrees),
                 x: 40, y: 145, size: 10)
            text("Generated \(TimeService.dayLabel(Date(), timeZoneID: scene.timeZoneID))",
                 x: 40, y: 160, size: 9, color: .darkGray)
            line(y: 174)
            text("Shadows through the day", x: 40, y: 194, size: 15, bold: true)
            let times = [540, 720, 960]
            for (i, minutes) in times.enumerated() {
                let instant = TimeService.localInstant(on: result.day, minutes: minutes,
                                                       in: scene.timeZoneID)
                let area = CGRect(x: 40 + CGFloat(i) * 173, y: 228, width: 160, height: 168)
                drawSite(scene, in: area, at: instant)
                text(TimeService.clock(instant, timeZoneID: scene.timeZoneID),
                     x: area.minX + 3, y: area.maxY + 9, size: 10, bold: true)
            }
            line(y: 440)
            text("Solar day", x: 40, y: 461, size: 15, bold: true)
            let events = result.events
            let status = events.alwaysAbove ? "Continuous daylight" :
                (events.alwaysBelow ? "No solar daylight" : "Daylight / sunset")
            text("Sunrise", x: 42, y: 494, size: 11, color: .darkGray)
            text(TimeService.clock(events.sunrise, timeZoneID: scene.timeZoneID), x: 42, y: 512, size: 19, bold: true)
            text("Solar noon", x: 210, y: 494, size: 11, color: .darkGray)
            text(TimeService.clock(events.solarNoon, timeZoneID: scene.timeZoneID), x: 210, y: 512, size: 19, bold: true)
            text("Sunset", x: 415, y: 494, size: 11, color: .darkGray)
            text(TimeService.clock(events.sunset, timeZoneID: scene.timeZoneID), x: 415, y: 512, size: 19, bold: true)
            if events.alwaysAbove || events.alwaysBelow {
                text(status, x: 42, y: 548, size: 10, color: .darkGray)
            }
            line(y: 575)
            text("Model scope", x: 40, y: 593, size: 15, bold: true)
            wrapped("Horizontal ground, geometric opaque obstacles and theoretical direct solar rays.\n"
                    + "No cloud cover, topography, neighbouring unmodelled structures or leaf transparency.\n"
                    + "Sun path approximated from NOAA formulas; shadows are planning estimates, not site measurements.",
                    in: CGRect(x: 40, y: 620, width: 510, height: 90), size: 10)
            text("Created locally. No project data uploaded by SunShadowPad.", x: 40, y: 759, size: 9, color: .darkGray)

            pdf.beginPage()
            drawPageBase(page: page, section: "SCENE INVENTORY")
            text("Measured scene objects", x: 40, y: 84, size: 20, bold: true)
            text("Level ground assumed. Heights are metres above ground.", x: 40, y: 111, size: 9, color: .darkGray)
            text("Obstacles", x: 40, y: 142, size: 12, bold: true)
            if scene.elements.isEmpty {
                text("No obstacles defined.", x: 40, y: 166, size: 10)
            } else {
                for (i, element) in scene.elements.prefix(14).enumerated() {
                    let y = 166 + CGFloat(i) * 23
                    text(element.name, x: 40, y: y, size: 9)
                    var details = String(format: "%.1f × %.1f m · H %.1f m", element.width, element.depth, element.height)
                    if element.kind == .tree {
                        details += String(format: " · crown ∅ %.1f m", element.crownDiameter)
                    }
                    if element.isHidden { details += " · hidden" }
                    if element.isLocked { details += " · locked" }
                    text(details, x: 198, y: y, size: 8, color: .darkGray)
                }
            }
            text("Observation & planting areas", x: 40, y: 522, size: 12, bold: true)
            if scene.targets.isEmpty {
                text("No observation targets defined.", x: 40, y: 546, size: 10)
            } else {
                for (i, target) in scene.targets.prefix(10).enumerated() {
                    let y = 546 + CGFloat(i) * 23
                    text(target.name, x: 40, y: y, size: 9)
                    let area = target.isPoint ? "Point" :
                        String(format: "%.1f × %.1f m", target.width, target.depth)
                    text(String(format: "%@ · goal %.1f h", area, target.targetHours),
                         x: 300, y: y, size: 8, color: .darkGray)
                }
            }

            pdf.beginPage()
            drawPageBase(page: page, section: "EXPOSURE ANALYSIS")
            text("Theoretical direct sunlight", x: 40, y: 90, size: 21, bold: true)
            text("Sampling: every \(result.stepMinutes) min  •  Spatial grid: \(result.cols) × \(result.rows)",
                 x: 40, y: 122, size: 10, color: .darkGray)
            let heatFrame = CGRect(x: 78, y: 154, width: 440, height: 276)
            drawHeatmap(result: result, scene: scene, in: heatFrame)
            text("Cooler = fewer direct-sun hours     Warmer = more direct-sun hours",
                 x: 78, y: 442, size: 10)
            line(y: 471)
            text("Observation targets", x: 40, y: 486, size: 15, bold: true)
            if result.targets.isEmpty {
                text("No observation targets defined for this scene.", x: 40, y: 512, size: 11)
            } else {
                for (i, target) in result.targets.prefix(8).enumerated() {
                    let y = 518 + CGFloat(i) * 25
                    text(target.name, x: 40, y: y, size: 10)
                    text(String(format: "%.2f h / %.1f h target", target.sunnyHours, target.targetHours),
                         x: 305, y: y, size: 10)
                    text(target.meetsTarget ? "MEETS" : "BELOW", x: 480, y: y,
                         size: 10, bold: true, color: target.meetsTarget ? UIColor.systemGreen : .systemOrange)
                }
            }
            text("Area figures are spatial averages. Target achievement compares with user-entered thresholds.",
                 x: 40, y: 742, size: 9, color: .darkGray)
            text("Midpoint time sampling and approximate opaque canopy projection; not a survey.",
                 x: 40, y: 756, size: 9, color: .darkGray)

            if let comparison {
                pdf.beginPage()
                drawPageBase(page: page, section: "LAYOUT COMPARISON")
                text("\(scene.name)  vs  \(comparison.scene.name)", x: 40, y: 92, size: 19, bold: true)
                drawHeatmap(result: result, scene: scene,
                            in: CGRect(x: 40, y: 166, width: 250, height: 220))
                drawHeatmap(result: comparison.result, scene: comparison.scene,
                            in: CGRect(x: 306, y: 166, width: 250, height: 220))
                text("Original layout", x: 40, y: 405, size: 12, bold: true)
                text("Alternative layout", x: 307, y: 405, size: 12, bold: true)
                let averageA = result.heat.map(\.sunnyHours).reduce(0,+) / Double(max(1,result.heat.count))
                let averageB = comparison.result.heat.map(\.sunnyHours).reduce(0,+) / Double(max(1,comparison.result.heat.count))
                text(String(format: "Site-wide mean exposure: %.2f h  →  %.2f h", averageA, averageB),
                     x: 40, y: 460, size: 14, bold: true)
                text(String(format: "Change: %+.2f h", averageB-averageA),
                     x: 40, y: 493, size: 17, bold: true)
                wrapped("Comparison is meaningful only if location, time zone, ground dimensions, orientation and sampling match.",
                        in: CGRect(x: 40, y: 544, width: 510, height: 55), size: 10)
            }
        }
    }

    private static func drawPageBase(page: CGRect, section: String) {
        UIColor(red: 0.07, green: 0.12, blue: 0.19, alpha: 1).setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: page.width, height: 54))
        text("SUNSHADOWPAD", x: 40, y: 19, size: 15, bold: true, color: .white)
        text(section, x: 420, y: 22, size: 9, color: .white)
    }

    private static func drawSite(_ scene: SceneDocument, in rect: CGRect, at date: Date) {
        UIColor(red: 0.92, green: 0.95, blue: 0.91, alpha: 1).setFill()
        UIBezierPath(roundedRect: rect, cornerRadius: 7).fill()
        let scale = min((rect.width - 12) / CGFloat(scene.width), (rect.height - 12) / CGFloat(scene.height))
        func point(_ p: Point2) -> CGPoint {
            CGPoint(x: rect.midX + (CGFloat(p.x) - CGFloat(scene.width)/2) * scale,
                    y: rect.midY + (CGFloat(p.y) - CGFloat(scene.height)/2) * scale)
        }
        func path(_ poly: Polygon2) -> UIBezierPath {
            let shape = UIBezierPath()
            if let first = poly.points.first { shape.move(to: point(first)) }
            for node in poly.points.dropFirst() { shape.addLine(to: point(node)) }
            shape.close()
            return shape
        }
        let sun = SolarPositionEngine.position(at: date, latitude: scene.latitude,
                                               longitude: scene.longitude, timeZoneID: scene.timeZoneID)
        UIColor(red: 0.28, green: 0.42, blue: 0.49, alpha: 0.75).setFill()
        for polygon in ShadowGeometryEngine.shadowPolygons(for: scene, at: sun) { path(polygon).fill() }
        UIColor(red: 0.54, green: 0.60, blue: 0.59, alpha: 1).setFill()
        for element in scene.activeElements { path(ShadowGeometryEngine.footprint(of: element)).fill() }
        UIColor.systemGreen.setStroke()
        for target in scene.targets where !target.isPoint {
            let p = point(Point2(x: target.x, y: target.y))
            let area = CGRect(x: p.x - CGFloat(target.width)/2*scale, y: p.y-CGFloat(target.depth)/2*scale,
                              width: CGFloat(target.width)*scale, height: CGFloat(target.depth)*scale)
            UIBezierPath(rect: area).stroke()
        }
    }

    private static func drawHeatmap(result: ExposureResult, scene: SceneDocument, in rect: CGRect) {
        UIColor(red: 0.92, green: 0.95, blue: 0.95, alpha: 1).setFill()
        UIRectFill(rect)
        let s = min(rect.width / CGFloat(scene.width), rect.height / CGFloat(scene.height))
        let originX = rect.midX - CGFloat(scene.width) * s / 2
        let originY = rect.midY - CGFloat(scene.height) * s / 2
        for cell in result.heat {
            let ratio = CGFloat(result.maxSunHours > 0 ? cell.sunnyHours / result.maxSunHours : 0)
            UIColor(red: 0.20 + 0.78 * ratio, green: 0.30 + 0.48 * ratio,
                    blue: 0.51 - 0.26 * ratio, alpha: 1).setFill()
            UIRectFill(CGRect(x: originX + CGFloat(cell.x)*s, y: originY + CGFloat(cell.y)*s,
                              width: CGFloat(cell.width)*s + 0.1, height: CGFloat(cell.height)*s + 0.1))
        }
    }

    private static func text(_ string: String, x: CGFloat, y: CGFloat, size: CGFloat,
                             bold: Bool = false, color: UIColor = .black) {
        let font: UIFont = bold ? .boldSystemFont(ofSize: size) : .systemFont(ofSize: size)
        (string as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: [.font: font, .foregroundColor: color])
    }
    private static func wrapped(_ value: String, in rect: CGRect, size: CGFloat) {
        (value as NSString).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: size),
                                                           .foregroundColor: UIColor.darkGray])
    }
    private static func line(y: CGFloat) {
        UIColor.lightGray.setStroke()
        let line = UIBezierPath(); line.move(to: CGPoint(x: 40, y: y))
        line.addLine(to: CGPoint(x: 555, y: y)); line.lineWidth = 0.6; line.stroke()
    }
}
