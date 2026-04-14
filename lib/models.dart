import 'package:flutter/material.dart';

/// Tier colors and shape definitions for nodes
const List<Color> tierColors = [
  Color(0xFF00FF88), // T1 基础
  Color(0xFF00C3FF), // T2 脉冲
  Color(0xFFB700FF), // T3 引力
  Color(0xFFFF00AA), // T4 相位
  Color(0xFFFFEA00), // T5 星环
];

const List<String> tierNames = ['基础', '脉冲', '引力', '相位', '星环'];
const List<int> tierSides = [3, 4, 5, 6, 8]; // polygon sides

/// A mergeable node on the bottom grid
class GameNode {
  int tier; // 1-5
  int col;
  int row;
  double vx; // visual X (with easing)
  double vy; // visual Y (with easing)
  double scale; // spawn animation scale

  GameNode(
    this.tier,
    this.col,
    this.row, {
    this.vx = 0,
    this.vy = 0,
    this.scale = 1,
  });

  double get targetX => 0; // set by game engine
  double get targetY => 0; // set by game engine
}

/// An enemy coming down the pseudo-3D track
class Enemy {
  final int trackIdx;
  double y; // world Y: from VPy to BaseY
  double baseSpeed;
  double hp;
  double maxHp;
  int tier; // 1-3 enemy tier
  bool markedForDeath;
  EnemyType type; // scout, normal, tank, boss, splitter, shield
  double slowFactor; // 1.0 = normal, <1.0 = slowed
  double slowTimer;
  double shieldHp; // for shield enemies

  Enemy({
    required this.trackIdx,
    required this.y,
    required this.baseSpeed,
    required this.hp,
    required this.maxHp,
    this.tier = 1,
    this.markedForDeath = false,
    this.type = EnemyType.normal,
    this.slowFactor = 1.0,
    this.slowTimer = 0,
    this.shieldHp = 0,
  });

  double get effectiveSpeed => baseSpeed * slowFactor;

  // Enemy visual size based on type
  double get visualSize {
    switch (type) {
      case EnemyType.scout:
        return 12.0 + tier * 4;
      case EnemyType.normal:
        return 18.0 + tier * 6;
      case EnemyType.tank:
        return 24.0 + tier * 8;
      case EnemyType.boss:
        return 35.0 + tier * 10;
      case EnemyType.splitter:
        return 16.0 + tier * 5;
      case EnemyType.shield:
        return 20.0 + tier * 7;
    }
  }

  // Enemy color based on type
  Color get visualColor {
    switch (type) {
      case EnemyType.scout:
        return const Color(0xFFFFAA00); // Orange
      case EnemyType.normal:
        return const Color(0xFFFF003C); // Red
      case EnemyType.tank:
        return const Color(0xFFAA00FF); // Purple
      case EnemyType.boss:
        return const Color(0xFFFF0000); // Deep red
      case EnemyType.splitter:
        return const Color(0xFF00FFAA); // Mint green
      case EnemyType.shield:
        return const Color(0xFF4488FF); // Blue
    }
  }
}

enum EnemyType { scout, normal, tank, boss, splitter, shield }

/// Projectile fired by towers
class Projectile {
  final int trackIdx;
  double x;
  double y;
  final int tier;
  final double speed;
  final double damage;
  final Color color;
  final TowerAbility ability;
  bool markedForDeath;

  Projectile({
    required this.trackIdx,
    required this.x,
    required this.y,
    required this.tier,
    this.speed = 300,
    required this.damage,
    required this.color,
    this.ability = TowerAbility.normal,
    this.markedForDeath = false,
  });
}

/// A tower deployed on a track (upper screen)
class Tower {
  int tier;
  double fireTimer;
  TowerAbility ability;

  Tower({
    required this.tier,
    this.fireTimer = 0,
    this.ability = TowerAbility.normal,
  });
}

enum TowerAbility { normal, slow, aoe, splash }

/// Visual particle for explosions/effects
class Particle {
  double x, y;
  double vx, vy;
  double life;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.life,
    required this.color,
  });
}

/// Buff card for the Deep Space Protocol (3-select-1)
class Buff {
  final String name;
  final String tier; // R, SR, SSR
  final Color tierColor;
  final String icon;
  final String description;
  final VoidCallback action;

  Buff({
    required this.name,
    required this.tier,
    required this.tierColor,
    required this.icon,
    required this.description,
    required this.action,
  });
}

/// Represents a slot position on the grid
class GridSlot {
  final int col;
  final int row;
  GridSlot(this.col, this.row);
}
