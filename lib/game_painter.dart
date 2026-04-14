import 'dart:math';
import 'package:flutter/material.dart';
import 'models.dart';
import 'perspective.dart';

/// CustomPainter that renders the entire game scene with enhanced visuals
class GamePainter extends CustomPainter {
  final double vpX, vpY, baseY;
  final List<double> tracksX;
  final int trackCount;
  final Rect gridRect;
  final double cellSize;
  final List<List<GameNode?>> grid;
  final List<Tower?> towers;
  final List<Enemy> enemies;
  final List<Projectile> projectiles;
  final List<Particle> particles;
  final GameNode? dragNode;
  final double dragCurrentX, dragCurrentY;
  final bool dragActive;
  final double overclockTimer;
  final int combo;
  final double comboTimer;
  final bool blackHoleWarn;
  final double stardust;
  final double baseHp;
  final int wave;
  final PerspectiveProjection projection;
  final double sizeW, sizeH;

  // Animation time
  final double animTime;

  // HUD height for spacing
  final double hudHeight;

  static const int gridCols = 4;
  static const int gridRows = 4;

  GamePainter({
    required this.vpX,
    required this.vpY,
    required this.baseY,
    required this.tracksX,
    required this.trackCount,
    required this.gridRect,
    required this.cellSize,
    required this.grid,
    required this.towers,
    required this.enemies,
    required this.projectiles,
    required this.particles,
    this.dragNode,
    required this.dragCurrentX,
    required this.dragCurrentY,
    required this.dragActive,
    required this.overclockTimer,
    required this.combo,
    required this.comboTimer,
    required this.blackHoleWarn,
    required this.stardust,
    required this.baseHp,
    required this.wave,
    required this.projection,
    required this.sizeW,
    required this.sizeH,
    this.animTime = 0,
    this.hudHeight = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawPerspectiveTracks(canvas, size);

    // Y-sort enemies for depth ordering
    final sortedEnemies = List<Enemy>.from(enemies)
      ..sort((a, b) => a.y.compareTo(b.y));
    for (final e in sortedEnemies) {
      _drawEnemy(canvas, e);
    }

    for (final p in projectiles) {
      _drawProjectile(canvas, p);
    }

    _drawDividerAndCombo(canvas, size);
    _drawGridAndNodes(canvas, size);
    _drawBlackHole(canvas, size);

    // Draw dragged node on top
    if (dragActive && dragNode != null) {
      _drawDraggedNode(canvas, dragNode!);
    }

    _drawParticles(canvas);

    // Vignette overlay (drawn last for cinematic feel)
    _drawVignette(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    // Deep space gradient background
    final bgGrad = RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: const [Color(0xFF0A0E1A), Color(0xFF050810), Color(0xFF020308)],
      stops: const [0.0, 0.6, 1.0],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, sizeW, sizeH),
      Paint()..shader = bgGrad.createShader(Rect.fromLTWH(0, 0, sizeW, sizeH)),
    );

    // Nebula effects in upper screen
    final nebulaPaint = Paint()..style = PaintingStyle.fill;
    final t = animTime;

    // Nebula 1 - purple
    final n1x = sizeW * 0.3 + sin(t * 0.2) * 30;
    final n1y = baseY * 0.3 + cos(t * 0.15) * 20;
    final n1Grad = RadialGradient(
      colors: [const Color(0xFF4A0080).withOpacity(0.15), Colors.transparent],
    );
    canvas.drawCircle(
      Offset(n1x, n1y),
      sizeW * 0.4,
      nebulaPaint
        ..shader = n1Grad.createShader(
          Rect.fromCircle(center: Offset(n1x, n1y), radius: sizeW * 0.4),
        ),
    );

    // Nebula 2 - blue
    final n2x = sizeW * 0.7 + cos(t * 0.25) * 25;
    final n2y = baseY * 0.5 + sin(t * 0.18) * 15;
    final n2Grad = RadialGradient(
      colors: [const Color(0xFF0040A0).withOpacity(0.12), Colors.transparent],
    );
    canvas.drawCircle(
      Offset(n2x, n2y),
      sizeW * 0.35,
      nebulaPaint
        ..shader = n2Grad.createShader(
          Rect.fromCircle(center: Offset(n2x, n2y), radius: sizeW * 0.35),
        ),
    );

    // Parallax stars - multiple layers
    _drawStarField(canvas, t);

    // Vanishing point glow
    final vpGrad = RadialGradient(
      colors: [
        const Color(0xFF00F0FF).withOpacity(0.1 + sin(t) * 0.05),
        const Color(0xFF00F0FF).withOpacity(0.03),
        Colors.transparent,
      ],
    );
    canvas.drawCircle(
      Offset(vpX, vpY.clamp(0, sizeH)),
      60,
      Paint()
        ..shader = vpGrad.createShader(
          Rect.fromCircle(center: Offset(vpX, vpY.clamp(0, sizeH)), radius: 60),
        ),
    );
  }

  void _drawStarField(Canvas canvas, double t) {
    final rng = Random(42);
    for (var i = 0; i < 120; i++) {
      final baseX = rng.nextDouble() * sizeW;
      final baseYpos = rng.nextDouble() * baseY;
      final size = rng.nextDouble() * 2.0 + 0.3;
      final twinkleSpeed = rng.nextDouble() * 3 + 1;
      final brightness = (0.3 + 0.7 * (0.5 + 0.5 * sin(t * twinkleSpeed + i)));

      // Parallax: stars drift slowly
      final driftX = sin(t * 0.1 + i * 0.5) * 5 * (size / 2);
      final x = baseX + driftX;
      final y = baseYpos;

      canvas.drawCircle(
        Offset(x, y),
        size,
        Paint()
          ..color = Colors.white.withOpacity(brightness.clamp(0.0, 1.0) * 0.6),
      );
    }
  }

  void _drawPerspectiveTracks(Canvas canvas, Size size) {
    final t = animTime;

    for (var i = 0; i < trackCount; i++) {
      final baseX = tracksX[i];
      final towerTier = towers[i]?.tier;
      final trackColor = towerTier != null
          ? tierColors[towerTier - 1]
          : const Color(0xFF1A2A3A);

      final finalColor = overclockTimer > 0
          ? const Color(0xFFFF4466)
          : trackColor;

      // Draw track with slight wave distortion for "gravitational distortion" effect
      final path = Path();
      path.moveTo(baseX, baseY);

      for (double y = baseY; y > vpY; y -= 2) {
        final p = projection.project(baseX, y);
        // Add subtle wave distortion
        final wave = sin(y * 0.02 + t * 2) * (3 * (1 - p.scale));
        if (y == baseY) {
          path.moveTo(p.x + wave, p.y);
        } else {
          path.lineTo(p.x + wave, p.y);
        }
      }

      final trackPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = towerTier != null ? 2.5 : 1.5
        ..color = finalColor.withOpacity(towerTier != null ? 0.8 : 0.3)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          towerTier != null ? 8 : 3,
        );
      canvas.drawPath(path, trackPaint);

      // Track base platform - hexagonal pad
      _drawHexPlatform(
        canvas,
        Offset(baseX, baseY),
        finalColor,
        towerTier != null,
      );

      // Draw tower if present
      if (towers[i] != null) {
        final t = towers[i]!;
        _drawTower(canvas, baseX, baseY, t);
      }
    }
  }

  void _drawHexPlatform(
    Canvas canvas,
    Offset center,
    Color color,
    bool hasTower,
  ) {
    final platformPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withOpacity(hasTower ? 0.15 : 0.08)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, hasTower ? 12 : 5);

    // Hexagonal platform
    final path = Path();
    final r = hasTower ? 25.0 : 18.0;
    for (var i = 0; i < 6; i++) {
      final angle = i * pi / 3 - pi / 6;
      final px = center.dx + cos(angle) * r;
      final py = center.dy + sin(angle) * r * 0.4; // Flatten for perspective
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, platformPaint);

    platformPaint
      ..style = PaintingStyle.stroke
      ..color = color.withOpacity(hasTower ? 0.6 : 0.2)
      ..strokeWidth = 1.5
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, platformPaint);
  }

  void _drawTower(Canvas canvas, double baseX, double baseY, Tower tower) {
    final t = animTime;
    final tier = tower.tier;
    final color = tierColors[tier - 1];
    final towerH = 30.0 + tier * 8;

    // Rotating ring(s) around tower base
    final ringCount = min(tier, 4);
    for (var r = 0; r < ringCount; r++) {
      final ringRadius = 18.0 + r * 6;
      final ringSpeed = 1.0 + r * 0.3;
      final ringAngle = t * ringSpeed * (r % 2 == 0 ? 1 : -1);

      canvas.save();
      canvas.translate(baseX, baseY - 10);

      // Draw orbital ring segments
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = color.withOpacity(0.4 - r * 0.08)
        ..strokeWidth = 1.5
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);

      canvas.rotate(ringAngle);
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: ringRadius),
        0.0,
        pi * 1.2,
        false,
        ringPaint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: ringRadius),
        pi * 1.5,
        pi * 0.8,
        false,
        ringPaint,
      );

      canvas.restore();
    }

    // Tower core (glowing pillar)
    final coreGrad = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [color.withOpacity(0.9), color.withOpacity(0.3)],
    );

    final corePath = Path()
      ..moveTo(baseX - 8, baseY - 5)
      ..lineTo(baseX - 5 - tier * 2, baseY - towerH)
      ..lineTo(baseX + 5 + tier * 2, baseY - towerH)
      ..lineTo(baseX + 8, baseY - 5)
      ..close();

    canvas.drawPath(
      corePath,
      Paint()
        ..shader = coreGrad.createShader(
          Rect.fromLTWH(baseX - 20, baseY - towerH - 10, 40, towerH + 10),
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Tower tip glow
    final tipGrad = RadialGradient(
      colors: [
        color.withOpacity(0.8),
        color.withOpacity(0.2),
        Colors.transparent,
      ],
    );
    canvas.drawCircle(
      Offset(baseX, baseY - towerH),
      8 + tier * 2,
      Paint()
        ..shader = tipGrad.createShader(
          Rect.fromCircle(
            center: Offset(baseX, baseY - towerH),
            radius: 8 + tier * 2,
          ),
        ),
    );

    // Ability indicator ring (for T3+ towers)
    if (tier >= 3) {
      final abilityColor = tier >= 4
          ? const Color(0xFFFF00AA) // AoE - pink
          : const Color(0xFF00C3FF); // Slow/Splash - cyan
      canvas.drawCircle(
        Offset(baseX, baseY - towerH),
        14 + tier * 2,
        Paint()
          ..color = abilityColor.withOpacity(0.3 + 0.1 * sin(t * 3))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // Tier number badge
    final badgeR = 8.0;
    canvas.drawCircle(
      Offset(baseX, baseY - towerH - 14),
      badgeR,
      Paint()
        ..color = const Color(0xFF0A0E1A)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      Offset(baseX, baseY - towerH - 14),
      badgeR,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    _drawText(canvas, '$tier', Offset(baseX, baseY - towerH - 14), color, 10);
  }

  void _drawEnemy(Canvas canvas, Enemy e) {
    final p = projection.project(tracksX[e.trackIdx], e.y);

    canvas.save();
    canvas.translate(p.x, p.y);
    canvas.scale(p.scale, p.scale);

    final size = e.visualSize;
    final t = animTime;
    final color = e.visualColor;

    // Enemy trail
    _drawEnemyTrail(canvas, e, p.scale);

    // Slow indicator
    if (e.slowTimer > 0) {
      canvas.drawCircle(
        Offset(0, 0),
        size + 8,
        Paint()
          ..color = const Color(0xFF00C3FF).withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6),
      );
    }

    // Enemy body - different shapes per type
    final bodyPaint = Paint()
      ..color = const Color(0xFF1A0008)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    final bodyPath = Path();
    switch (e.type) {
      case EnemyType.scout:
        // Small triangle (fast)
        bodyPath
          ..moveTo(0, size)
          ..lineTo(-size * 0.6, -size * 0.5)
          ..lineTo(size * 0.6, -size * 0.5)
          ..close();
        break;
      case EnemyType.normal:
        // Diamond shape
        bodyPath
          ..moveTo(0, size)
          ..lineTo(-size * 0.7, 0)
          ..lineTo(0, -size * 0.6)
          ..lineTo(size * 0.7, 0)
          ..close();
        break;
      case EnemyType.tank:
        // Hexagon (bulky)
        for (var i = 0; i < 6; i++) {
          final angle = i * pi / 3 - pi / 2;
          final px = cos(angle) * size * 0.8;
          final py = sin(angle) * size * 0.8;
          if (i == 0) {
            bodyPath.moveTo(px, py);
          } else {
            bodyPath.lineTo(px, py);
          }
        }
        bodyPath.close();
        break;
      case EnemyType.boss:
        // Octagon with inner star
        for (var i = 0; i < 8; i++) {
          final angle = i * pi / 4 - pi / 2;
          final r = i % 2 == 0 ? size : size * 0.6;
          final px = cos(angle) * r;
          final py = sin(angle) * r;
          if (i == 0) {
            bodyPath.moveTo(px, py);
          } else {
            bodyPath.lineTo(px, py);
          }
        }
        bodyPath.close();
        break;
      case EnemyType.splitter:
        // Double circle (splitting)
        canvas.drawCircle(Offset(-size * 0.25, 0), size * 0.55, bodyPaint);
        canvas.drawCircle(Offset(size * 0.25, 0), size * 0.55, bodyPaint);
        bodyPath.addOval(
          Rect.fromCircle(center: Offset.zero, radius: size * 0.7),
        );
        break;
      case EnemyType.shield:
        // Shield shape (pentagon with outer ring)
        for (var i = 0; i < 5; i++) {
          final angle = i * pi * 2 / 5 - pi / 2;
          final px = cos(angle) * size * 0.7;
          final py = sin(angle) * size * 0.7;
          if (i == 0) {
            bodyPath.moveTo(px, py);
          } else {
            bodyPath.lineTo(px, py);
          }
        }
        bodyPath.close();
        break;
    }
    canvas.drawPath(bodyPath, bodyPaint);

    // Enemy outline with pulsing glow
    final pulse = 0.7 + 0.3 * sin(t * 5 + e.trackIdx);
    bodyPaint
      ..style = PaintingStyle.stroke
      ..color = color.withOpacity(pulse)
      ..strokeWidth = e.type == EnemyType.boss ? 3 : 2
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        e.type == EnemyType.boss ? 12 : 8,
      );
    canvas.drawPath(bodyPath, bodyPaint);

    // Inner core with color matching enemy type
    final coreGrad = RadialGradient(
      colors: [color.withOpacity(0.6), color.withOpacity(0.1)],
    );
    canvas.drawCircle(
      Offset(0, 0),
      size * 0.3,
      Paint()
        ..shader = coreGrad.createShader(
          Rect.fromCircle(center: Offset.zero, radius: size * 0.3),
        ),
    );

    // Shield indicator
    if (e.shieldHp > 0) {
      final shieldRatio = (e.shieldHp / (20 + e.tier * 5)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(0, 0),
        size + 6,
        Paint()
          ..color = const Color(0xFF4488FF).withOpacity(0.2 + shieldRatio * 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8),
      );
      // Shield HP text
      _drawText(
        canvas,
        '🛡${e.shieldHp.floor()}',
        Offset(0, -size - 18),
        const Color(0xFF4488FF),
        10,
      );
    }

    // Boss: rotating inner ring
    if (e.type == EnemyType.boss) {
      canvas.save();
      canvas.rotate(t * 2);
      canvas.drawCircle(
        Offset(0, 0),
        size * 0.7,
        Paint()
          ..color = color.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8),
      );
      canvas.restore();
    }

    // HP bar with background
    if (e.hp < e.maxHp) {
      final barW = size * 2;
      const barH = 5.0;
      final barY = -size - 12;

      // HP bar background
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-size, barY, barW, barH),
          const Radius.circular(2.5),
        ),
        Paint()..color = const Color(0xFF220010),
      );

      // HP bar fill with gradient
      final hpRatio = (e.hp / e.maxHp).clamp(0.0, 1.0);
      final hpGrad = LinearGradient(colors: [color, color.withOpacity(0.7)]);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-size, barY, barW * hpRatio, barH),
          const Radius.circular(2.5),
        ),
        Paint()
          ..shader = hpGrad.createShader(
            Rect.fromLTWH(-size, barY, barW * hpRatio, barH),
          ),
      );
    }

    // Type indicator for boss/tank
    if (e.type == EnemyType.boss) {
      _drawText(
        canvas,
        '💀',
        Offset(0, -size - 24),
        const Color(0xFFFF0000),
        14,
      );
    }

    canvas.restore();
  }

  void _drawEnemyTrail(Canvas canvas, Enemy e, double scale) {
    // Small trailing particles behind enemy
    final trailLength = 5;
    final color = e.visualColor;
    for (var i = 1; i <= trailLength; i++) {
      final trailY = e.y - i * 8 * scale;
      final p = projection.project(tracksX[e.trackIdx], trailY);
      final trailAlpha = (1 - i / trailLength) * 0.3 * scale;
      final trailSize = (3 + e.tier * 2) * (1 - i / trailLength) * scale;

      canvas.drawCircle(
        Offset(p.x, p.y),
        trailSize,
        Paint()
          ..color = color.withOpacity(trailAlpha)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  void _drawProjectile(Canvas canvas, Projectile p) {
    final proj = projection.project(p.x, p.y);

    canvas.save();
    canvas.translate(proj.x, proj.y);
    canvas.scale(proj.scale, proj.scale);

    // Projectile glow trail
    final trailPaint = Paint()
      ..color = p.color.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset.zero, 6 + p.tier * 2, trailPaint);

    // Core
    final corePaint = Paint()
      ..color = Colors.white
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0 + p.tier.toDouble());
    canvas.drawCircle(Offset.zero, 2.0 + p.tier.toDouble() * 0.8, corePaint);

    // Outer colored ring
    final ringPaint = Paint()
      ..color = p.color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset.zero, 3.0 + p.tier.toDouble(), ringPaint);

    canvas.restore();
  }

  void _drawDividerAndCombo(Canvas canvas, Size size) {
    // Base line - glowing energy line
    final dividerGrad = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: overclockTimer > 0
          ? const [Color(0xFFFF003C), Color(0xFFFF6688), Color(0xFFFF003C)]
          : const [Color(0xFF00F0FF), Color(0xFF66FFFF), Color(0xFF00F0FF)],
    );

    canvas.drawLine(
      Offset(0, baseY),
      Offset(sizeW, baseY),
      Paint()
        ..shader = dividerGrad.createShader(
          Rect.fromLTWH(0, baseY - 2, sizeW, 4),
        )
        ..strokeWidth = 3
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Subtle line core
    canvas.drawLine(
      Offset(0, baseY),
      Offset(sizeW, baseY),
      Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..strokeWidth = 1,
    );

    // Combo bar - positioned between divider and grid
    if (comboTimer > 0 || combo > 0) {
      const barW = 160.0;
      const barH = 6.0;
      final cx = sizeW / 2 - barW / 2;
      final cy = baseY + 10;

      // Combo bar background
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx, cy, barW, barH),
          const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFF111820),
      );

      // Combo bar fill - energy style
      final fillRatio = (combo / 5.0).clamp(0.0, 1.0);
      if (fillRatio > 0) {
        final comboGrad = LinearGradient(
          colors: combo >= 4
              ? const [Color(0xFFFFEA00), Color(0xFFFF8800)]
              : const [Color(0xFF00F0FF), Color(0xFF66FFFF)],
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx, cy, barW * fillRatio, barH),
            const Radius.circular(3),
          ),
          Paint()
            ..shader = comboGrad.createShader(
              Rect.fromLTWH(cx, cy, barW * fillRatio, barH),
            )
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6),
        );
      }

      // Combo text
      final comboText = combo > 0 ? 'COMBO x$combo' : 'COMBO';
      final comboColor = combo >= 4
          ? const Color(0xFFFFEA00)
          : const Color(0xFF00F0FF);
      _drawText(
        canvas,
        comboText,
        Offset(sizeW / 2, cy + barH + 10),
        comboColor,
        11,
        bold: true,
      );

      // Combo glow on screen edges
      if (combo > 0) {
        final edgeGlowAlpha = (combo / 5.0).clamp(0.0, 0.3);
        final edgeGrad = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            comboColor.withOpacity(edgeGlowAlpha),
            Colors.transparent,
            comboColor.withOpacity(edgeGlowAlpha),
          ],
        );
        canvas.drawRect(
          Rect.fromLTWH(0, baseY, sizeW, sizeH - baseY),
          Paint()
            ..shader = edgeGrad.createShader(
              Rect.fromLTWH(0, baseY, sizeW, sizeH - baseY),
            ),
        );
      }
    }

    // Zone label: "防线" at divider center
    _drawText(
      canvas,
      '防线',
      Offset(sizeW / 2, baseY - 16),
      overclockTimer > 0 ? const Color(0xFFFF4466) : const Color(0xFF336688),
      10,
      bold: true,
    );

    // "合成棋盘" title - positioned above combo bar, between divider and grid
    final titleY = baseY + 2;

    // Title background pill
    final titlePainter = TextPainter(
      text: const TextSpan(
        text: '✦ 合成棋盘 ✦',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();

    final pillW = titlePainter.width + 16;
    final pillH = 18.0;
    final pillRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(sizeW / 2 - pillW / 2, titleY - 3, pillW, pillH),
      const Radius.circular(9),
    );

    // Pill background
    canvas.drawRRect(
      pillRect,
      Paint()
        ..color = const Color(0xFF0A1525).withOpacity(0.7)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawRRect(
      pillRect,
      Paint()
        ..color = const Color(0xFF336699).withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    _drawText(
      canvas,
      '✦ 合成棋盘 ✦',
      Offset(sizeW / 2, titleY),
      const Color(0xFFBBEEFF),
      11,
      bold: true,
    );
  }

  void _drawGridAndNodes(Canvas canvas, Size size) {
    final t = animTime;

    // Grid background with subtle gradient
    final gridBgGrad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFF0A1020), Color(0xFF060C18)],
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(gridRect, const Radius.circular(12)),
      Paint()..shader = gridBgGrad.createShader(gridRect),
    );

    // Grid border with glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(gridRect, const Radius.circular(12)),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFF1A3050)
        ..strokeWidth = 1.5
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Grid cells with rounded corners
    for (var c = 0; c < gridCols; c++) {
      for (var r = 0; r < gridRows; r++) {
        final cellRect = Rect.fromLTWH(
          gridRect.left + c * cellSize + 3,
          gridRect.top + r * cellSize + 3,
          cellSize - 6,
          cellSize - 6,
        ).inflate(-2);

        // Cell background
        final cellPaint = Paint()
          ..color = const Color(0xFF0D1520)
          ..style = PaintingStyle.fill;
        canvas.drawRRect(
          RRect.fromRectAndRadius(cellRect, const Radius.circular(8)),
          cellPaint,
        );

        // Cell border with subtle animated highlight
        final cellPulse = 0.5 + 0.5 * sin(t * 1.5 + c + r);
        cellPaint
          ..style = PaintingStyle.stroke
          ..color = Color.lerp(
            const Color(0xFF1A2840),
            const Color(0xFF2A4860),
            cellPulse * 0.3,
          )!
          ..strokeWidth = 1;
        canvas.drawRRect(
          RRect.fromRectAndRadius(cellRect, const Radius.circular(8)),
          cellPaint,
        );
      }
    }

    // Draw nodes
    for (var c = 0; c < gridCols; c++) {
      for (var r = 0; r < gridRows; r++) {
        final node = grid[c][r];
        if (node != null) {
          _drawNode(canvas, node, isDragged: false);
        }
      }
    }
  }

  void _drawNode(Canvas canvas, GameNode node, {bool isDragged = false}) {
    final x = node.vx;
    final y = node.vy;
    final scale = node.scale;

    // If being dragged and in upper screen, apply perspective
    double drawX = x;
    double drawY = y;
    double drawScale = scale;

    if (isDragged && y < baseY) {
      final trackIdx = (drawX / (sizeW / trackCount)).floor().clamp(
        0,
        trackCount - 1,
      );
      final targetTrackX = tracksX[trackIdx];
      drawX += (targetTrackX - drawX) * 0.5;
      final p = projection.project(drawX, drawY);
      drawX = p.x;
      drawY = p.y;
      drawScale *= p.scale;
    }

    final t = animTime;
    final color = tierColors[node.tier - 1];
    final sides = tierSides[node.tier - 1];
    final r = cellSize * 0.32;
    final pulse = 1 + 0.03 * sin(t * 2 + node.tier);

    canvas.save();
    canvas.translate(drawX, drawY);
    final finalScale = (isDragged ? drawScale * 1.15 : drawScale) * pulse;
    canvas.scale(finalScale, finalScale);

    // Tier-specific visual enhancements
    // T1: Breathing pulse
    if (node.tier == 1) {
      final pulseR = r + 8 + sin(t * 3) * 3;
      canvas.drawCircle(
        Offset.zero,
        pulseR,
        Paint()
          ..color = color.withOpacity(0.08)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // T2: Orbiting particles
    if (node.tier == 2) {
      for (var i = 0; i < 3; i++) {
        final angle = (i / 3) * pi * 2 + t * 2;
        final orbitR = r + 8;
        final px = cos(angle) * orbitR;
        final py = sin(angle) * orbitR;
        canvas.drawCircle(
          Offset(px, py),
          2,
          Paint()
            ..color = color.withOpacity(0.5 + 0.3 * sin(t * 5 + i))
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }

    // T3: Gravity wave rings
    if (node.tier == 3) {
      for (var w = 0; w < 2; w++) {
        final wavePhase = (t * 2 + w * pi) % (pi * 2);
        final waveR = r + 5 + wavePhase * 5;
        final waveAlpha = (1 - wavePhase / (pi * 2)) * 0.2;
        canvas.drawCircle(
          Offset.zero,
          waveR,
          Paint()
            ..color = color.withOpacity(waveAlpha)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }

    // T4+: rotating outer particles
    if (node.tier >= 4) {
      final particleCount = node.tier == 5 ? 8 : 6;
      for (var i = 0; i < particleCount; i++) {
        final angle =
            (i / particleCount) * pi * 2 + t * (node.tier == 5 ? 1.5 : -1);
        final orbitR = r + 10 + node.tier * 2;
        final px = cos(angle) * orbitR;
        final py = sin(angle) * orbitR;
        canvas.drawCircle(
          Offset(px, py),
          2,
          Paint()
            ..color = color.withOpacity(0.5 + 0.3 * sin(t * 4 + i))
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
        );
      }
    }

    // Outer glow ring (tier-dependent)
    final glowPaint = Paint()
      ..color = color.withOpacity(0.15 + node.tier * 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 + node.tier * 0.3
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 + node.tier * 3);
    canvas.drawCircle(Offset.zero, r + 4 + node.tier * 2, glowPaint);

    // Polygon body with gradient fill for higher tiers
    if (node.tier >= 3) {
      final innerGrad = RadialGradient(
        colors: [color.withOpacity(0.35), color.withOpacity(0.08)],
      );
      canvas.drawPath(
        _createPolygon(r, sides),
        Paint()
          ..shader = innerGrad.createShader(
            Rect.fromCircle(center: Offset.zero, radius: r),
          ),
      );
    }

    // Polygon outline
    final polygonPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(_createPolygon(r, sides), polygonPaint);

    // Inner subtle fill for all tiers
    canvas.drawPath(
      _createPolygon(r - 2, sides),
      Paint()..color = color.withOpacity(0.1),
    );

    // T5 (Star Ring): special golden ring effect
    if (node.tier == 5) {
      canvas.drawCircle(
        Offset.zero,
        r * 0.6,
        Paint()
          ..color = const Color(0xFFFFEA00).withOpacity(0.2 + 0.1 * sin(t * 3))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8),
      );
      // Inner golden core
      canvas.drawCircle(
        Offset.zero,
        r * 0.3,
        Paint()
          ..color = const Color(0xFFFFEA00).withOpacity(0.4)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6),
      );
    }

    // Tier label with enhanced shadow for readability
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      shadows: [
        const Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 1)),
        Shadow(color: color, blurRadius: 10),
      ],
    );
    final textSpan = TextSpan(text: 'T${node.tier}', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );

    canvas.restore();
  }

  void _drawDraggedNode(Canvas canvas, GameNode node) {
    _drawNode(canvas, node, isDragged: true);

    // Additional drag indicator: dashed line to nearest valid target
    if (dragCurrentY < baseY) {
      // Drawing to upper screen - show target track
      final trackIdx = (dragCurrentX / (sizeW / trackCount)).floor().clamp(
        0,
        trackCount - 1,
      );
      final targetX = tracksX[trackIdx];

      canvas.save();
      // Dashed line
      final dashPaint = Paint()
        ..color = tierColors[node.tier - 1].withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);

      final path = Path();
      path.moveTo(dragCurrentX, dragCurrentY);
      path.lineTo(targetX, baseY);
      canvas.drawPath(path, dashPaint);

      // Target indicator
      canvas.drawCircle(
        Offset(targetX, baseY),
        12,
        Paint()
          ..color = tierColors[node.tier - 1].withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      canvas.restore();
    }
  }

  Path _createPolygon(double radius, int sides) {
    final path = Path();
    for (var i = 0; i < sides; i++) {
      final angle = i * (pi * 2 / sides) - pi / 2;
      final px = cos(angle) * radius;
      final py = sin(angle) * radius;
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    return path;
  }

  void _drawBlackHole(Canvas canvas, Size size) {
    final bhX = sizeW / 2;
    // Position black hole below the grid with proper spacing
    final bhY = (gridRect.bottom + sizeH) / 2;
    final t = animTime;

    // Pulsing animation
    final pulse = 1 + sin(t * 3) * 0.08;
    final color = blackHoleWarn
        ? const Color(0xFFFF003C)
        : const Color(0xFF9D00FF);

    canvas.save();
    canvas.translate(bhX, bhY);
    canvas.scale(pulse, pulse);

    // Background glow
    final bgGrad = RadialGradient(
      colors: [color.withOpacity(0.08), Colors.transparent],
    );
    canvas.drawCircle(
      Offset.zero,
      70,
      Paint()
        ..shader = bgGrad.createShader(
          Rect.fromCircle(center: Offset.zero, radius: 70),
        ),
    );

    // Outer vortex rings
    for (var i = 0; i < 3; i++) {
      final ringR = 35.0 + i.toDouble() * 8;
      final angle = t * (2 + i * 0.5) * (i % 2 == 0 ? 1 : -1);

      canvas.save();
      canvas.rotate(angle);

      final ringPaint = Paint()
        ..color = color.withOpacity(0.15 - i.toDouble() * 0.04)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: ringR),
        0.0,
        pi * 1.5,
        false,
        ringPaint,
      );
      canvas.restore();
    }

    // Core black hole
    final bhGrad = RadialGradient(
      colors: [
        Colors.black,
        color.withOpacity(0.6),
        color.withOpacity(0.1),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 0.8, 1.0],
    );
    canvas.drawCircle(
      Offset.zero,
      45,
      Paint()
        ..shader = bhGrad.createShader(
          Rect.fromCircle(center: Offset.zero, radius: 45),
        ),
    );

    // Tap hint circle
    final hintAlpha = 0.1 + 0.08 * sin(t * 2);
    canvas.drawCircle(
      Offset.zero,
      55,
      Paint()
        ..color = color.withOpacity(hintAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Warning flash
    if (blackHoleWarn) {
      final warnAlpha = 0.3 + 0.3 * sin(t * 8);
      canvas.drawCircle(
        Offset.zero,
        50,
        Paint()
          ..color = const Color(0xFFFF003C).withOpacity(warnAlpha)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15),
      );
    }

    canvas.restore();

    // Label with background
    final labelY = bhY - 60;
    // Label background pill
    final labelPainter = TextPainter(
      text: const TextSpan(
        text: '🌀 黑洞回收',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();

    final pillRect = Rect.fromCenter(
      center: Offset(bhX, labelY),
      width: labelPainter.width + 20,
      height: 22,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(pillRect, const Radius.circular(11)),
      Paint()
        ..color = blackHoleWarn
            ? const Color(0xFFFF003C).withOpacity(0.15)
            : const Color(0xFF9D00FF).withOpacity(0.1)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(pillRect, const Radius.circular(11)),
      Paint()
        ..color = blackHoleWarn
            ? const Color(0xFFFF003C).withOpacity(0.3)
            : const Color(0xFF9D00FF).withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    _drawText(
      canvas,
      '🌀 黑洞回收',
      Offset(bhX, labelY - 6),
      blackHoleWarn ? const Color(0xFFFF003C) : const Color(0xFFCC88FF),
      11,
      bold: true,
    );
    _drawText(
      canvas,
      '双击清除最低阶 (10✦)',
      Offset(bhX, labelY + 12),
      const Color(0xFF887799),
      8,
    );
  }

  void _drawParticles(Canvas canvas) {
    for (final p in particles) {
      if (p.life <= 0) continue;
      final alpha = p.life.clamp(0.0, 1.0);
      final particlePaint = Paint()
        ..color = p.color.withOpacity(alpha)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);
      final s = 2 + alpha * 3;
      canvas.drawCircle(Offset(p.x, p.y), s, particlePaint);
    }
  }

  void _drawVignette(Canvas canvas, Size size) {
    // Screen edge darkening for cinematic feel
    final vignetteGrad = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: const [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.4)],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, sizeW, sizeH),
      Paint()
        ..shader = vignetteGrad.createShader(Rect.fromLTWH(0, 0, sizeW, sizeH)),
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset pos,
    Color color,
    double fontSize, {
    bool bold = false,
  }) {
    final textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(pos.dx - textPainter.width / 2, pos.dy));
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}
