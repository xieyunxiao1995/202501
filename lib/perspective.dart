/// Pseudo-3D single-point perspective projection utility
///
/// Maps 2D world coordinates (x, y) into a trapezoidal perspective
/// with a vanishing point above the screen.
class PerspectiveProjection {
  final double vanishingPointX;
  final double vanishingPointY;
  final double baseY;

  PerspectiveProjection({
    required this.vanishingPointX,
    required this.vanishingPointY,
    required this.baseY,
  });

  /// Project world coordinates to screen coordinates.
  ///
  /// When y >= baseY, returns identity (flat 2D space below the defense line).
  /// When y < baseY, applies perspective scaling:
  ///   scale = (y - vpY) / (baseY - vpY)
  ///   screenX = vpX + (worldX - vpX) * scale
  PerspectiveResult project(double worldX, double worldY) {
    if (worldY >= baseY) {
      return PerspectiveResult(x: worldX, y: worldY, scale: 1.0);
    }
    double scale = (worldY - vanishingPointY) / (baseY - vanishingPointY);
    if (scale < 0.01) scale = 0.01;
    double screenX = vanishingPointX + (worldX - vanishingPointX) * scale;
    return PerspectiveResult(x: screenX, y: worldY, scale: scale);
  }

  /// Get the screen X coordinate for a track index at the base line.
  double trackXAtBase(int trackIdx, int trackCount, double screenWidth) {
    double spacing = screenWidth / (trackCount + 1);
    return spacing * (trackIdx + 1);
  }
}

class PerspectiveResult {
  final double x;
  final double y;
  final double scale;

  PerspectiveResult({required this.x, required this.y, required this.scale});
}
