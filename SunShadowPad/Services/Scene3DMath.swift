import Foundation
import simd

/// Maps the plan-view scene into a right-handed 3D site.
/// Scene Y grows toward the viewer (south) and world Z matches it, so north is -Z.
enum Scene3DMath {
    private static let radians = Double.pi / 180

    static func worldPoint(x: Double, y: Double, sceneWidth: Double, sceneHeight: Double) -> SIMD3<Float> {
        SIMD3<Float>(Float(x - sceneWidth / 2), 0, Float(y - sceneHeight / 2))
    }

    static func sitePosition(fromWorld point: SIMD3<Float>, sceneWidth: Double, sceneHeight: Double) -> (x: Double, y: Double) {
        (Double(point.x) + sceneWidth / 2, Double(point.z) + sceneHeight / 2)
    }

    /// Direction from the site toward the sun, incorporating the scene's rotated north.
    static func sunDirection(elevation: Double, azimuth: Double, northDegrees: Double) -> SIMD3<Float> {
        let elevationRadians = elevation * radians
        let bearing = (azimuth + northDegrees) * radians
        let horizontal = cos(elevationRadians)
        return SIMD3<Float>(Float(sin(bearing) * horizontal),
                            Float(sin(elevationRadians)),
                            Float(-cos(bearing) * horizontal))
    }

    /// Plan-view rotation is clockwise on screen; SceneKit's Y rotation is counter-clockwise from above.
    static func rotationY(degrees: Double) -> Float {
        Float(-degrees * radians)
    }

    static func clampToSite(_ x: Double, _ y: Double, width: Double, height: Double) -> (x: Double, y: Double) {
        (min(width, max(0, x)), min(height, max(0, y)))
    }

    static func cameraPosition(azimuth: Double, elevation: Double, radius: Double,
                               center: SIMD3<Float>) -> SIMD3<Float> {
        let azimuthRadians = azimuth * radians
        let elevationRadians = elevation * radians
        let horizontal = Float(radius * cos(elevationRadians))
        return SIMD3<Float>(center.x + horizontal * Float(sin(azimuthRadians)),
                            center.y + Float(radius * sin(elevationRadians)),
                            center.z + horizontal * Float(cos(azimuthRadians)))
    }
}
