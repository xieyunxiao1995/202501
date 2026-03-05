import 'package:flutter/material.dart';
import 'dart:ui';

/// 游戏通用背景组件
/// 提供统一的背景图和黑色半透明遮罩效果
class GameBackground extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final double overlayOpacity;
  final bool useGradientOverlay;
  final List<Widget>? additionalChildren;

  const GameBackground({
    super.key,
    required this.child,
    this.backgroundImage,
    this.overlayOpacity = 0.2,
    this.useGradientOverlay = true,
    this.additionalChildren,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景图片层
        Positioned.fill(child: _buildBackground()),
        // 渐变遮罩层 - 让背景图更清晰可见
        if (useGradientOverlay)
          Positioned.fill(child: _buildGradientOverlay())
        else
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(overlayOpacity)),
          ),
        // 内容层
        child,
        // 额外的装饰层（如光效、粒子等）
        if (additionalChildren != null) ...additionalChildren!,
      ],
    );
  }

  Widget _buildBackground() {
    if (backgroundImage != null) {
      return Image.asset(backgroundImage!, fit: BoxFit.cover);
    }
    // 默认使用渐变背景
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff1a1c23), Color(0xff0f172a), Color(0xff020617)],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    // 使用渐变遮罩，边缘暗中间亮，让背景图更清晰
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Colors.black.withValues(alpha: overlayOpacity * 0.15), // 中心更透明
            Colors.black.withValues(alpha: overlayOpacity * 0.4), // 中间过渡
            Colors.black.withValues(alpha: overlayOpacity * 0.8), // 边缘稍暗
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
    );
  }
}

/// 带模糊效果的游戏背景组件
class GameBackgroundWithBlur extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final double overlayOpacity;
  final double blurSigma;

  const GameBackgroundWithBlur({
    super.key,
    required this.child,
    this.backgroundImage,
    this.overlayOpacity = 0.25,
    this.blurSigma = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景图片层（带模糊）
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Image.asset(backgroundImage!, fit: BoxFit.cover),
            ),
          ),
        ),
        // 渐变遮罩层
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.black.withValues(alpha: overlayOpacity * 0.3),
                  Colors.black.withValues(alpha: overlayOpacity * 0.6),
                  Colors.black.withValues(alpha: overlayOpacity),
                ],
              ),
            ),
          ),
        ),
        // 内容层
        child,
      ],
    );
  }
}

/// 背景图工具类
class BackgroundUtil {
  static const String _basePath = 'assets/Bg/';

  /// 根据索引获取背景图路径
  static String getBgByIndex(int index, {int total = 24}) {
    final safeIndex = ((index - 1) % total + total) % total + 1;
    return '$_basePath/bg-$safeIndex.jpeg';
  }

  /// 根据场景名称获取背景图
  static String getBgByScene(String scene) {
    switch (scene.toLowerCase()) {
      case 'splash':
        return '$_basePath/bg-1.jpeg';
      case 'hub':
      case '旅館':
      case '旅馆':
        return '$_basePath/bg-6.jpeg'; // メイン画面は bg-6 を使用
      case 'gacha':
      case '召喚':
      case '召唤':
        return '$_basePath/bg-10.jpeg'; // 召喚画面は bg-10 を使用
      case 'heroes':
      case '英雄':
        return '$_basePath/bg-21.jpeg'; // 英雄画面は bg-21 を使用
      case 'combat':
      case '探険':
      case '探险':
      case 'battle':
        return '$_basePath/bg-5.jpeg';
      case 'combat_map':
        return '$_basePath/bg-6.jpeg';
      case 'hero_detail':
        return '$_basePath/bg-7.jpeg';
      case 'inventory':
      case 'バックパック':
      case '背包':
        return '$_basePath/bg-8.jpeg';
      case 'tasks':
      case 'クエスト':
      case '任务':
        return '$_basePath/bg-9.jpeg';
      case 'login_bonus':
      case 'ログイン':
      case '登录':
        return '$_basePath/bg-10.jpeg';
      case 'monster_park':
      case '遊園地':
      case '游园':
        return '$_basePath/bg-11.jpeg';
      case 'hot_spring':
      case '温泉':
        return '$_basePath/bg-12.jpeg';
      case 'store':
      case '商店':
      case '商柜':
        return '$_basePath/bg-13.jpeg';
      case 'preview':
      case 'お知らせ':
      case '公告':
        return '$_basePath/bg-14.jpeg';
      default:
        return '$_basePath/bg-1.jpeg';
    }
  }

  /// シーン別のおすすめオーバーレイ不透明度を取得 (0.15-0.25 範囲、背景画像をより鮮明に)
  static double getOverlayOpacityForScene(String scene) {
    switch (scene.toLowerCase()) {
      case 'splash':
        return 0.18; // スプラッシュ画面はより鮮明に
      case 'hub':
      case '旅館':
      case '旅馆':
        return 0.20; // メイン画面は背景をはっきりと
      case 'gacha':
      case '召喚':
      case '召唤':
        return 0.22; // 召喚画面は雰囲気を重視
      case 'heroes':
      case '英雄':
        return 0.18; // 英雄リストは鮮明に
      case 'combat':
      case '探険':
      case '探险':
      case 'battle':
        return 0.20;
      case 'combat_map':
        return 0.18;
      case 'hero_detail':
        return 0.20;
      case 'inventory':
      case 'バックパック':
      case '背包':
        return 0.18; // バックパックはアイテムをはっきりと
      case 'tasks':
      case 'クエスト':
      case '任务':
        return 0.18;
      case 'login_bonus':
      case 'ログイン':
      case '登录':
        return 0.20;
      case 'monster_park':
      case '遊園地':
      case '游园':
        return 0.18;
      case 'hot_spring':
      case '温泉':
        return 0.18;
      case 'store':
      case '商店':
      case '商柜':
        return 0.20;
      case 'preview':
      case 'お知らせ':
      case '公告':
        return 0.18;
      default:
        return 0.18;
    }
  }
}
