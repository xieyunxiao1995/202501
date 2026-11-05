import Foundation

enum ShadowGeometryEngine {
    private static let radians = Double.pi / 180

    static func footprint(of object: SceneElement) -> Polygon2 {
        if object.kind == .column || object.kind == .tree {
            let r = (object.kind == .tree ? object.crownDiameter : object.width) / 2
            return circle(center: Point2(x: object.x, y: object.y), radius: max(0.05, r))
        }
        let hw = max(0.01, object.width) / 2
        let hd = max(0.01, object.depth) / 2
        let angle = object.rotation * radians
        let c = cos(angle), s = sin(angle)
        let corners = [(-hw,-hd),(hw,-hd),(hw,hd),(-hw,hd)]
        return Polygon2(points: corners.map { dx, dy in
            Point2(x: object.x + dx * c - dy * s, y: object.y + dx * s + dy * c)
        })
    }

    static func shadowOffset(height: Double, sun: SunPosition, northDegrees: Double,
                             maxDrawDistance: Double = 20000) -> Point2 {
        guard sun.elevation > 0, height > 0 else { return Point2(x: 0, y: 0) }
        let length = min(maxDrawDistance, height / tan(max(sun.elevation, 0.01) * radians))
        let shadowBearing = (sun.azimuth + 180 + northDegrees) * radians
        return Point2(x: sin(shadowBearing) * length, y: -cos(shadowBearing) * length)
    }

    static func shadowPolygons(for scene: SceneDocument, at sun: SunPosition) -> [Polygon2] {
        guard sun.isAboveHorizon else { return [] }
        var results: [Polygon2] = []
        for object in scene.activeElements where object.height > 0 {
            let base = footprint(of: object)
            let offset = shadowOffset(height: object.kind == .tree
                                        ? max(0.1, object.height - object.crownDiameter * 0.25) : object.height,
                                      sun: sun, northDegrees: scene.northDegrees)
            let translated = base.points.map { $0 + offset }
            if object.kind == .canopy || object.kind == .tree {
                // Opaque canopy/treetop projection: no solid volume down to the ground.
                results.append(Polygon2(points: translated))
                if object.kind == .tree {
                    let trunk = circle(center: Point2(x: object.x, y: object.y), radius: 0.10)
                    results.append(Polygon2(points: convexHull(trunk.points + trunk.points.map { $0 + offset })))
                }
            } else {
                // Solid extruded prism: union of footprint and projected top vertices.
                results.append(Polygon2(points: convexHull(base.points + translated)))
            }
        }
        return results
    }

    static func blockers(at point: Point2, scene: SceneDocument, sun: SunPosition) -> [String] {
        guard sun.isAboveHorizon else { return [] }
        return scene.activeElements.filter { obj in
            let individual = SceneDocument(name: scene.name, kind: scene.kind, latitude: scene.latitude,
                                           longitude: scene.longitude, timeZoneID: scene.timeZoneID,
                                           width: scene.width, height: scene.height,
                                           northDegrees: scene.northDegrees, elements: [obj])
            return shadowPolygons(for: individual, at: sun).contains { contains(point, polygon: $0) }
        }.map(\.name)
    }

    static func isShaded(_ p: Point2, polygons: [Polygon2]) -> Bool {
        polygons.contains { contains(p, polygon: $0) }
    }

    static func contains(_ point: Point2, polygon: Polygon2) -> Bool {
        let ps = polygon.points
        guard ps.count >= 3 else { return false }
        var within = false
        var j = ps.count - 1
        for i in ps.indices {
            let a = ps[i], b = ps[j]
            if ((a.y > point.y) != (b.y > point.y)) &&
                (point.x < (b.x - a.x) * (point.y - a.y) / (b.y - a.y) + a.x) { within.toggle() }
            j = i
        }
        return within
    }

    private static func circle(center: Point2, radius: Double, sides: Int = 24) -> Polygon2 {
        Polygon2(points: (0..<sides).map { i in
            let t = Double(i) / Double(sides) * 2 * .pi
            return Point2(x: center.x + cos(t) * radius, y: center.y + sin(t) * radius)
        })
    }

    private static func convexHull(_ points: [Point2]) -> [Point2] {
        let sorted = points.sorted { $0.x == $1.x ? $0.y < $1.y : $0.x < $1.x }
        guard sorted.count > 2 else { return sorted }
        func cross(_ a: Point2, _ b: Point2, _ c: Point2) -> Double {
            (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
        }
        var lower: [Point2] = []
        for p in sorted {
            while lower.count >= 2 && cross(lower[lower.count-2], lower[lower.count-1], p) <= 0 { lower.removeLast() }
            lower.append(p)
        }
        var upper: [Point2] = []
        for p in sorted.reversed() {
            while upper.count >= 2 && cross(upper[upper.count-2], upper[upper.count-1], p) <= 0 { upper.removeLast() }
            upper.append(p)
        }
        lower.removeLast(); upper.removeLast()
        return lower + upper
    }
}
