import 'package:flutter/material.dart';

/// 稀有度
enum Rarity {
  n(label: '普通', color: 0xFF9E9E9E),
  r(label: '稀有', color: 0xFF42A5F5),
  sr(label: '史诗', color: 0xFFAB47BC),
  ssr(label: '传说', color: 0xFFFFB300),
  ur(label: '至尊', color: 0xFFFF6F00),
  legendary(label: '绝世', color: 0xFFF44336);

  const Rarity({required this.label, required this.color});

  final String label;
  final int color;

  Color get materialColor => Color(color);

  static Rarity fromJson(String json) => Rarity.values.firstWhere(
        (e) => e.name == json,
        orElse: () => Rarity.n,
      );

  String toJson() => name;
}
