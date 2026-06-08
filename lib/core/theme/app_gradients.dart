/// 渐变样式定义
///
/// 提供应用中所需的各类渐变效果，包括：
/// - 稀有度边框渐变：从N到绝世各稀有度的光效渐变
/// - 按钮渐变：主按钮、次按钮的渐变
/// - 金色闪光渐变：用于SSR/UR招募动画等
library;

import 'package:flutter/material.dart';

/// 应用渐变样式
///
/// 所有渐变集中定义，统一管理颜色、方向和停靠点。
/// 使用方式：`AppGradients.raritySSR` 获取SSR稀有度渐变。
class AppGradients {
  AppGradients._();

  // ==================== 稀有度边框渐变 ====================

  /// 普通(N)边框渐变 - 灰色调
  static const LinearGradient rarityN = LinearGradient(
    colors: [
      Color(0xFF9E9E9E),
      Color(0xFFBDBDBD),
      Color(0xFF9E9E9E),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// 稀有(R)边框渐变 - 蓝色调
  static const LinearGradient rarityR = LinearGradient(
    colors: [
      Color(0xFF1565C0),
      Color(0xFF42A5F5),
      Color(0xFF1565C0),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// 史诗(SR)边框渐变 - 紫色调
  static const LinearGradient raritySR = LinearGradient(
    colors: [
      Color(0xFF6A1B9A),
      Color(0xFFAB47BC),
      Color(0xFFE040FB),
      Color(0xFFAB47BC),
      Color(0xFF6A1B9A),
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  /// 传说(SSR)边框渐变 - 金色调，带光泽感
  static const LinearGradient raritySSR = LinearGradient(
    colors: [
      Color(0xFFFF8F00),
      Color(0xFFFFB300),
      Color(0xFFFFD54F),
      Color(0xFFFFB300),
      Color(0xFFFF8F00),
    ],
    stops: [0.0, 0.2, 0.5, 0.8, 1.0],
  );

  /// 至尊(UR)边框渐变 - 橙金调，火焰质感
  static const LinearGradient rarityUR = LinearGradient(
    colors: [
      Color(0xFFE65100),
      Color(0xFFFF6F00),
      Color(0xFFFFB300),
      Color(0xFFFFD54F),
      Color(0xFFFFB300),
      Color(0xFFFF6F00),
      Color(0xFFE65100),
    ],
    stops: [0.0, 0.15, 0.3, 0.5, 0.7, 0.85, 1.0],
  );

  /// 绝世(Legendary)边框渐变 - 红金调，最强光效
  static const LinearGradient rarityLegendary = LinearGradient(
    colors: [
      Color(0xFFB71C1C),
      Color(0xFFF44336),
      Color(0xFFFFB300),
      Color(0xFFFFD54F),
      Color(0xFFFFB300),
      Color(0xFFF44336),
      Color(0xFFB71C1C),
    ],
    stops: [0.0, 0.15, 0.3, 0.5, 0.7, 0.85, 1.0],
  );

  /// 根据稀有度获取对应边框渐变
  ///
  /// [rarity] 稀有度标识，如 'N', 'R', 'SR', 'SSR', 'UR', 'L'
  static LinearGradient getRarityGradient(String rarity) {
    return switch (rarity.toUpperCase()) {
      'N' => rarityN,
      'R' => rarityR,
      'SR' => raritySR,
      'SSR' => raritySSR,
      'UR' => rarityUR,
      'L' || 'LEGENDARY' => rarityLegendary,
      _ => rarityN,
    };
  }

  // ==================== 按钮渐变 ====================

  /// 主按钮渐变 - 朱红渐变，用于"确认"、"出战"等主要操作
  static const LinearGradient buttonPrimary = LinearGradient(
    colors: [
      Color(0xFFB71C1C),
      Color(0xFFC62828),
      Color(0xFFE53935),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 次按钮渐变 - 青绿渐变，用于"取消"、"返回"等次要操作
  static const LinearGradient buttonSecondary = LinearGradient(
    colors: [
      Color(0xFF1B5E20),
      Color(0xFF2E7D32),
      Color(0xFF388E3C),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 金色按钮渐变 - 用于"充值"、"购买"等消费操作
  static const LinearGradient buttonGold = LinearGradient(
    colors: [
      Color(0xFFFF8F00),
      Color(0xFFFFB300),
      Color(0xFFFFD54F),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 暗色按钮渐变 - 用于禁用态或低调操作
  static const LinearGradient buttonDark = LinearGradient(
    colors: [
      Color(0xFF212121),
      Color(0xFF424242),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ==================== 金色闪光渐变 ====================

  /// 金色闪光渐变 - 用于SSR/UR招募动画、稀有物品展示
  ///
  /// 此渐变通常配合动画使用，通过 [AnimationController] 改变
  /// 渐变的 transform 实现流光效果。
  static const LinearGradient goldenShimmer = LinearGradient(
    colors: [
      Color(0xFFFFB300),
      Color(0xFFFFD54F),
      Color(0xFFFFECB3),
      Color(0xFFFFD54F),
      Color(0xFFFFB300),
    ],
    stops: [0.0, 0.3, 0.5, 0.7, 1.0],
  );

  /// 红色闪光渐变 - 用于Legendary招募动画、绝世武将展示
  static const LinearGradient legendaryShimmer = LinearGradient(
    colors: [
      Color(0xFFC62828),
      Color(0xFFEF5350),
      Color(0xFFFFCDD2),
      Color(0xFFEF5350),
      Color(0xFFC62828),
    ],
    stops: [0.0, 0.3, 0.5, 0.7, 1.0],
  );

  // ==================== 背景渐变 ====================

  /// 页面顶部渐变 - 从深色到透明，用于页面顶部装饰
  static const LinearGradient pageTopDecoration = LinearGradient(
    colors: [
      Color(0xFF3E2723),
      Colors.transparent,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 卡片底部渐变 - 从透明到深色，用于卡片底部文字遮罩
  static const LinearGradient cardBottomOverlay = LinearGradient(
    colors: [
      Colors.transparent,
      Color(0xE01A1A1A),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 武将卡片背景渐变 - 深褐到墨黑
  static const LinearGradient generalCardBackground = LinearGradient(
    colors: [
      Color(0xFF4E342E),
      Color(0xFF3E2723),
      Color(0xFF1A1A1A),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ==================== 阵营渐变 ====================

  /// 魏国渐变 - 蓝色调
  static const LinearGradient kingdomWei = LinearGradient(
    colors: [
      Color(0xFF0D47A1),
      Color(0xFF1565C0),
      Color(0xFF1976D2),
    ],
  );

  /// 蜀国渐变 - 红色调
  static const LinearGradient kingdomShu = LinearGradient(
    colors: [
      Color(0xFFB71C1C),
      Color(0xFFC62828),
      Color(0xFFE53935),
    ],
  );

  /// 吴国渐变 - 绿色调
  static const LinearGradient kingdomWu = LinearGradient(
    colors: [
      Color(0xFF1B5E20),
      Color(0xFF2E7D32),
      Color(0xFF43A047),
    ],
  );

  /// 群雄渐变 - 紫色调
  static const LinearGradient kingdomQun = LinearGradient(
    colors: [
      Color(0xFF4A148C),
      Color(0xFF6A1B9A),
      Color(0xFF8E24AA),
    ],
  );

  /// 晋国渐变 - 灰蓝色调
  static const LinearGradient kingdomJin = LinearGradient(
    colors: [
      Color(0xFF263238),
      Color(0xFF37474F),
      Color(0xFF546E7A),
    ],
  );

  /// 根据阵营获取对应渐变
  ///
  /// [kingdom] 阵营标识，如 'wei', 'shu', 'wu', 'qun', 'jin'
  static LinearGradient getKingdomGradient(String kingdom) {
    return switch (kingdom.toLowerCase()) {
      'wei' => kingdomWei,
      'shu' => kingdomShu,
      'wu' => kingdomWu,
      'qun' => kingdomQun,
      'jin' => kingdomJin,
      _ => kingdomShu,
    };
  }
}
