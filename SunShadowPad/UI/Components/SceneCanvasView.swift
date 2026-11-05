import SwiftUI

struct CanvasProjection {
    let scene: SceneDocument
    let viewport: CGSize
    let zoom: CGFloat
    let pan: CGSize

    var scale: CGFloat {
        min((viewport.width - 28) / CGFloat(max(1, scene.width)),
            (viewport.height - 28) / CGFloat(max(1, scene.height))) * zoom
    }
    func point(_ p: Point2) -> CGPoint {
        CGPoint(x: viewport.width / 2 + (CGFloat(p.x) - CGFloat(scene.width) / 2) * scale + pan.width,
                y: viewport.height / 2 + (CGFloat(p.y) - CGFloat(scene.height) / 2) * scale + pan.height)
    }
    func rectangle(x: Double, y: Double, width: Double, height: Double) -> CGRect {
        let topLeft = point(Point2(x: x, y: y))
        return CGRect(x: topLeft.x, y: topLeft.y,
                      width: CGFloat(width) * scale, height: CGFloat(height) * scale)
    }
    func scenePoint(fromViewPoint viewPoint: CGPoint) -> Point2? {
        let x = (viewPoint.x - viewport.width / 2 - pan.width) / scale + CGFloat(scene.width) / 2
        let y = (viewPoint.y - viewport.height / 2 - pan.height) / scale + CGFloat(scene.height) / 2
        guard x >= 0, y >= 0, x <= CGFloat(scene.width), y <= CGFloat(scene.height) else { return nil }
        return Point2(x: Double(x), y: Double(y))
    }
}

struct SceneCanvasView: View {
    let scene: SceneDocument
    let moment: Date
    var selectedElement: UUID? = nil
    var heatmap: ExposureResult? = nil
    var showsGrid: Bool = true
    var allowsInteraction: Bool = false
    var onSelectElement: ((UUID) -> Void)? = nil
    var onSelectTarget: ((UUID) -> Void)? = nil
    var onMoveElement: ((UUID, Double, Double) -> Void)? = nil
    var onMoveTarget: ((UUID, Double, Double) -> Void)? = nil
    var onSelectHeatCell: ((HeatCell) -> Void)? = nil
    var highlightedHeatCellID: Int? = nil

    @State private var zoom: CGFloat = 1
    @State private var zoomStart: CGFloat = 1
    @State private var pan: CGSize = .zero
    @State private var panStart: CGSize = .zero

    private var sun: SunPosition {
        SolarPositionEngine.position(at: moment, latitude: scene.latitude,
                                     longitude: scene.longitude, timeZoneID: scene.timeZoneID)
    }

    var body: some View {
        GeometryReader { geometry in
            let projection = CanvasProjection(scene: scene, viewport: geometry.size, zoom: zoom, pan: pan)
            ZStack {
                Canvas(opaque: false) { context, size in
                    draw(in: context, size: size, projection: projection)
                }
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 12)
                    .onChanged { value in
                        guard allowsInteraction else { return }
                        pan = CGSize(width: panStart.width + value.translation.width,
                                     height: panStart.height + value.translation.height)
                    }
                    .onEnded { _ in panStart = pan })

                if let heatmap, let onSelectHeatCell {
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(SpatialTapGesture().onEnded { tap in
                            guard let point = projection.scenePoint(fromViewPoint: tap.location),
                                  let cell = heatmap.heat.first(where: {
                                      point.x >= $0.x && point.x <= $0.x + $0.width &&
                                      point.y >= $0.y && point.y <= $0.y + $0.height
                                  }) else { return }
                            onSelectHeatCell(cell)
                        })
                        .accessibilityHidden(true)
                }

                if allowsInteraction {
                    ForEach(scene.elements.filter { !$0.isHidden && !$0.isLocked }) { element in
                        let center = projection.point(Point2(x: element.x, y: element.y))
                        Rectangle().fill(Color.clear)
                            .frame(width: max(32, CGFloat(element.width) * projection.scale),
                                   height: max(32, CGFloat(element.depth) * projection.scale))
                            .contentShape(Rectangle())
                            .position(center)
                            .gesture(DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    if hypot(value.translation.width, value.translation.height) < 5 {
                                        onSelectElement?(element.id)
                                    } else {
                                        onMoveElement?(element.id,
                                                       Double(value.translation.width / projection.scale),
                                                       Double(value.translation.height / projection.scale))
                                    }
                                })
                    }
                    ForEach(scene.targets) { target in
                        let center = projection.point(Point2(x: target.x, y: target.y))
                        Circle().fill(.clear).frame(width: 38, height: 38)
                            .contentShape(Circle()).position(center)
                            .gesture(DragGesture(minimumDistance: 0).onEnded { value in
                                if hypot(value.translation.width, value.translation.height) < 5 {
                                    onSelectTarget?(target.id)
                                } else {
                                    onMoveTarget?(target.id,
                                                  Double(value.translation.width / projection.scale),
                                                  Double(value.translation.height / projection.scale))
                                }
                            })
                    }
                }
            }
            .simultaneousGesture(MagnifyGesture()
                .onChanged { value in zoom = min(8, max(0.7, zoomStart * value.magnification)) }
                .onEnded { _ in zoomStart = zoom })
            .clipped()
        }
        .background(AppTheme.navy, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(AppTheme.elevated, lineWidth: 1))
        .accessibilityLabel("Scale diagram of \(scene.name). Pinch to zoom.")
    }

    private func draw(in context: GraphicsContext, size: CGSize, projection p: CanvasProjection) {
        let ground = p.rectangle(x: 0, y: 0, width: scene.width, height: scene.height)
        context.fill(Path(ground), with: .color(Color(red: 0.10, green: 0.18, blue: 0.24)))
        context.stroke(Path(ground), with: .color(AppTheme.textMuted.opacity(0.4)), lineWidth: 1)

        if showsGrid {
            let step: Double = p.scale > 24 ? 1 : (p.scale > 8 ? 2 : 5)
            for x in stride(from: 0.0, through: scene.width, by: step) {
                let a = p.point(Point2(x: x, y: 0))
                let b = p.point(Point2(x: x, y: scene.height))
                var path = Path(); path.move(to: a); path.addLine(to: b)
                context.stroke(path, with: .color(.white.opacity(0.06)), lineWidth: 0.75)
            }
            for y in stride(from: 0.0, through: scene.height, by: step) {
                let a = p.point(Point2(x: 0, y: y))
                let b = p.point(Point2(x: scene.width, y: y))
                var path = Path(); path.move(to: a); path.addLine(to: b)
                context.stroke(path, with: .color(.white.opacity(0.06)), lineWidth: 0.75)
            }
        }

        if let heatmap {
            for cell in heatmap.heat {
                let ratio = heatmap.maxSunHours > 0 ? cell.sunnyHours / heatmap.maxSunHours : 0
                let color = Color(red: 0.24 + 0.76 * ratio,
                                  green: 0.31 + 0.44 * ratio,
                                  blue: 0.49 - 0.27 * ratio)
                context.fill(Path(p.rectangle(x: cell.x, y: cell.y,
                                              width: cell.width, height: cell.height)),
                             with: .color(color.opacity(0.9)))
            }
            if let id = highlightedHeatCellID,
               let cell = heatmap.heat.first(where: { $0.id == id }) {
                let rect = p.rectangle(x: cell.x, y: cell.y,
                                       width: cell.width, height: cell.height).insetBy(dx: 1, dy: 1)
                context.stroke(Path(rect), with: .color(AppTheme.yellow), lineWidth: 2)
            }
        } else {
            for polygon in ShadowGeometryEngine.shadowPolygons(for: scene, at: sun) {
                context.fill(path(polygon, projection: p), with: .color(AppTheme.shadow.opacity(0.86)))
            }
        }

        for target in scene.targets {
            let center = p.point(Point2(x: target.x, y: target.y))
            if target.isPoint {
                let outer = CGRect(x: center.x - 8, y: center.y - 8, width: 16, height: 16)
                context.fill(Path(ellipseIn: outer), with: .color(AppTheme.yellow))
                context.fill(Path(ellipseIn: outer.insetBy(dx: 4, dy: 4)), with: .color(AppTheme.navy))
            } else {
                let rect = CGRect(x: center.x - CGFloat(target.width) / 2 * p.scale,
                                  y: center.y - CGFloat(target.depth) / 2 * p.scale,
                                  width: CGFloat(target.width) * p.scale,
                                  height: CGFloat(target.depth) * p.scale)
                context.fill(Path(rect), with: .color(AppTheme.grass.opacity(0.23)))
                context.stroke(Path(rect), with: .color(AppTheme.grass), lineWidth: 2)
            }
        }

        for object in scene.activeElements {
            let outline = path(ShadowGeometryEngine.footprint(of: object), projection: p)
            let color: Color
            switch object.kind {
            case .tree: color = Color(red: 0.25, green: 0.61, blue: 0.39)
            case .wall, .fence: color = Color(red: 0.76, green: 0.77, blue: 0.76)
            case .canopy: color = Color(red: 0.52, green: 0.69, blue: 0.74)
            default: color = Color(red: 0.71, green: 0.68, blue: 0.58)
            }
            context.fill(outline, with: .color(color.opacity(object.isLocked ? 0.65 : 0.95)))
            context.stroke(outline,
                           with: .color(selectedElement == object.id ? AppTheme.yellow : AppTheme.navy),
                           lineWidth: selectedElement == object.id ? 3 : 1)
        }

        // Sun marker sits on the side of the site the sunlight arrives from.
        if sun.isAboveHorizon && heatmap == nil {
            let bearing = (sun.azimuth + scene.northDegrees) * .pi / 180
            let radius = max(40, min(size.width, size.height) / 2 - 26)
            let sunPoint = CGPoint(x: size.width / 2 + CGFloat(sin(bearing) * radius),
                                   y: size.height / 2 - CGFloat(cos(bearing) * radius))
            let disc: CGFloat = size.width < 260 ? 3.5 : 5.5
            context.fill(Path(ellipseIn: CGRect(x: sunPoint.x - disc, y: sunPoint.y - disc,
                                                width: disc * 2, height: disc * 2)),
                         with: .color(AppTheme.yellow))
            var rays = Path()
            for index in 0..<8 {
                let angle = Double(index) * .pi / 4
                let inner = disc + 3
                let outer = disc + (size.width < 260 ? 6 : 8)
                rays.move(to: CGPoint(x: sunPoint.x + CGFloat(cos(angle)) * inner,
                                      y: sunPoint.y + CGFloat(sin(angle)) * inner))
                rays.addLine(to: CGPoint(x: sunPoint.x + CGFloat(cos(angle)) * outer,
                                         y: sunPoint.y + CGFloat(sin(angle)) * outer))
            }
            context.stroke(rays, with: .color(AppTheme.yellow), lineWidth: 1.4)
        }

        // True-north compass remains visible after the user rotates the scene orientation.
        let north = scene.northDegrees * .pi / 180
        let origin = CGPoint(x: max(30, size.width - 35), y: 35)
        let tip = CGPoint(x: origin.x + CGFloat(sin(north) * 17), y: origin.y - CGFloat(cos(north) * 17))
        var arrow = Path(); arrow.move(to: origin); arrow.addLine(to: tip)
        context.stroke(arrow, with: .color(AppTheme.yellow), style: StrokeStyle(lineWidth: 3, lineCap: .round))
        context.draw(Text("N").font(.caption2.bold()).foregroundStyle(AppTheme.yellow),
                     at: CGPoint(x: tip.x, y: tip.y - 9))
        if !sun.isAboveHorizon && heatmap == nil {
            context.draw(Text("SUN BELOW HORIZON").font(.caption.bold()).foregroundStyle(.white.opacity(0.75)),
                         at: CGPoint(x: size.width / 2, y: size.height - 24))
        }
    }

    private func path(_ poly: Polygon2, projection: CanvasProjection) -> Path {
        var result = Path()
        guard let first = poly.points.first else { return result }
        result.move(to: projection.point(first))
        for pt in poly.points.dropFirst() { result.addLine(to: projection.point(pt)) }
        result.closeSubpath()
        return result
    }
}
