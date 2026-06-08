import 'package:flutter/material.dart';

/// 阵营
enum Kingdom {
  wei(label: '魏', color: 0xFF1565C0, emoji: '🔵'),
  shu(label: '蜀', color: 0xFFC62828, emoji: '🔴'),
  wu(label: '吴', color: 0xFF2E7D32, emoji: '🟢'),
  qun(label: '群', color: 0xFF6A1B9A, emoji: '🟣'),
  jin(label: '晋', color: 0xFF37474F, emoji: '⚪'),
  female(label: '女将', color: 0xFFAD1457, emoji: '🩷');

  const Kingdom({required this.label, required this.color, required this.emoji});

  final String label;
  final int color;
  final String emoji;

  Color get materialColor => Color(color);

  static Kingdom fromJson(String json) => Kingdom.values.firstWhere(
        (e) => e.name == json,
        orElse: () => Kingdom.wei,
      );

  String toJson() => name;
}
