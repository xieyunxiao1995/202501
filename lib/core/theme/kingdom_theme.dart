/// 阵营主题扩展
///
/// 通过 [ThemeExtension] 机制将阵营颜色集成到 ThemeData 中，
/// 使得阵营颜色可以通过 `Theme.of(context).extension<KingdomTheme>()` 获取，
/// 实现与 Material 主题系统的深度整合。
library;

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_gradients.dart';

/// 阵营主题扩展
///
/// 将三国阵营色（魏/蜀/吴/群/晋/女将）集成到 ThemeData 中，
/// 便于在 Widget 中通过 Theme 获取阵营色，而非硬编码。
///
/// 使用方式：
/// ```dart
/// final kingdomTheme = Theme.of(context).extension<KingdomTheme>()!;
/// final weiColor = kingdomTheme.weiColor;
/// ```
class KingdomTheme extends ThemeExtension<KingdomTheme> {
  /// 创建阵营主题
  const KingdomTheme({
    this.weiColor = AppColors.wei,
    this.shuColor = AppColors.shu,
    this.wuColor = AppColors.wu,
    this.qunColor = AppColors.qun,
    this.jinColor = AppColors.jin,
    this.femaleColor = AppColors.female,
    this.weiGradient = AppGradients.kingdomWei,
    this.shuGradient = AppGradients.kingdomShu,
    this.wuGradient = AppGradients.kingdomWu,
    this.qunGradient = AppGradients.kingdomQun,
    this.jinGradient = AppGradients.kingdomJin,
  });

  /// 魏国色 - 蓝色，代表曹操的雄才大略
  final Color weiColor;

  /// 蜀国色 - 红色，代表刘备的仁义忠勇
  final Color shuColor;

  /// 吴国色 - 绿色，代表孙权的英武
  final Color wuColor;

  /// 群雄色 - 紫色，代表群雄割据
  final Color qunColor;

  /// 晋国色 - 灰蓝色，代表司马氏
  final Color jinColor;

  /// 女将色 - 粉红色
  final Color femaleColor;

  /// 魏国渐变
  final LinearGradient weiGradient;

  /// 蜀国渐变
  final LinearGradient shuGradient;

  /// 吴国渐变
  final LinearGradient wuGradient;

  /// 群雄渐变
  final LinearGradient qunGradient;

  /// 晋国渐变
  final LinearGradient jinGradient;

  /// 根据阵营标识获取对应颜色
  ///
  /// [kingdom] 阵营标识，如 'wei', 'shu', 'wu', 'qun', 'jin', 'female'
  Color getColor(String kingdom) {
    return switch (kingdom.toLowerCase()) {
      'wei' => weiColor,
      'shu' => shuColor,
      'wu' => wuColor,
      'qun' => qunColor,
      'jin' => jinColor,
      'female' => femaleColor,
      _ => shuColor,
    };
  }

  /// 根据阵营标识获取对应渐变
  ///
  /// [kingdom] 阵营标识
  LinearGradient getGradient(String kingdom) {
    return switch (kingdom.toLowerCase()) {
      'wei' => weiGradient,
      'shu' => shuGradient,
      'wu' => wuGradient,
      'qun' => qunGradient,
      'jin' => jinGradient,
      _ => shuGradient,
    };
  }

  /// 获取阵营对应的深色变体（用于背景）
  Color getDarkColor(String kingdom) {
    final color = getColor(kingdom);
    return Color.lerp(color, Colors.black, 0.3)!;
  }

  /// 获取阵营对应的浅色变体（用于高亮）
  Color getLightColor(String kingdom) {
    final color = getColor(kingdom);
    return Color.lerp(color, Colors.white, 0.3)!;
  }

  @override
  KingdomTheme copyWith({
    Color? weiColor,
    Color? shuColor,
    Color? wuColor,
    Color? qunColor,
    Color? jinColor,
    Color? femaleColor,
    LinearGradient? weiGradient,
    LinearGradient? shuGradient,
    LinearGradient? wuGradient,
    LinearGradient? qunGradient,
    LinearGradient? jinGradient,
  }) {
    return KingdomTheme(
      weiColor: weiColor ?? this.weiColor,
      shuColor: shuColor ?? this.shuColor,
      wuColor: wuColor ?? this.wuColor,
      qunColor: qunColor ?? this.qunColor,
      jinColor: jinColor ?? this.jinColor,
      femaleColor: femaleColor ?? this.femaleColor,
      weiGradient: weiGradient ?? this.weiGradient,
      shuGradient: shuGradient ?? this.shuGradient,
      wuGradient: wuGradient ?? this.wuGradient,
      qunGradient: qunGradient ?? this.qunGradient,
      jinGradient: jinGradient ?? this.jinGradient,
    );
  }

  @override
  KingdomTheme lerp(covariant KingdomTheme? other, double t) {
    if (other is! KingdomTheme) return this;
    return KingdomTheme(
      weiColor: Color.lerp(weiColor, other.weiColor, t)!,
      shuColor: Color.lerp(shuColor, other.shuColor, t)!,
      wuColor: Color.lerp(wuColor, other.wuColor, t)!,
      qunColor: Color.lerp(qunColor, other.qunColor, t)!,
      jinColor: Color.lerp(jinColor, other.jinColor, t)!,
      femaleColor: Color.lerp(femaleColor, other.femaleColor, t)!,
    );
  }
}
