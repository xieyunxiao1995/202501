import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../config/routes.dart';

/// 设置页面 - 深色霓虹风格（类似个人中心）
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  LinearGradient _getItemGradient(int index) {
    return AppColors.getGradientByIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final sectionSpacing = isSmallScreen ? 12.0 : 16.0;

    final settingsItems = [
      _SettingsItemData(
        icon: Icons.monetization_on_outlined,
        title: '代币充值',
        subtitle: '购买代币',
        route: AppRoutes.store,
      ),
      _SettingsItemData(
        icon: Icons.info_outline,
        title: '关于 CP嗒啧',
        subtitle: '了解本应用',
        route: AppRoutes.about,
      ),
      _SettingsItemData(
        icon: Icons.description_outlined,
        title: '用户协议',
        subtitle: '条款与条件',
        route: AppRoutes.userAgreement,
      ),
      _SettingsItemData(
        icon: Icons.privacy_tip_outlined,
        title: '隐私政策',
        subtitle: '我们如何处理您的数据',
        route: AppRoutes.privacyPolicy,
      ),
      _SettingsItemData(
        icon: Icons.help_outline,
        title: '帮助与教程',
        subtitle: '入门指南',
        route: AppRoutes.helpTutorial,
      ),
      _SettingsItemData(
        icon: Icons.feedback_outlined,
        title: '反馈与建议',
        subtitle: '分享您的想法',
        route: AppRoutes.feedback,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 头部区域
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  isSmallScreen ? 16 : 20,
                  horizontalPadding,
                  sectionSpacing,
                ),
                child: Text(
                  '设置',
                  style: AppTextStyles.headline1.copyWith(
                    fontSize: isSmallScreen ? 24 : 28,
                  ),
                ),
              ),
            ),
            // 功能列表
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                sectionSpacing,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
                    child: _buildSettingsItem(
                      gradient: _getItemGradient(index),
                      icon: settingsItems[index].icon,
                      title: settingsItems[index].title,
                      subtitle: settingsItems[index].subtitle,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(settingsItems[index].route),
                      isSmallScreen: isSmallScreen,
                    ),
                  );
                }, childCount: settingsItems.length),
              ),
            ),
            // 应用信息卡片
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  isSmallScreen ? 24 : 40,
                ),
                child: _buildAppInfoCard(isSmallScreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 设置项 - 深色卡片风格
  Widget _buildSettingsItem({
    required LinearGradient gradient,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    final iconSize = isSmallScreen ? 44.0 : 48.0;
    final iconInnerSize = isSmallScreen ? 22.0 : 24.0;
    final arrowSize = isSmallScreen ? 28.0 : 32.0;
    final arrowIconSize = isSmallScreen ? 18.0 : 20.0;
    final padding = isSmallScreen ? 14.0 : 16.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: AppDecorations.card(
          color: AppColors.surface,
          radius: isSmallScreen ? 18 : 20,
        ),
        child: Row(
          children: [
            // 图标容器 - 渐变背景
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withAlpha(128),
                    blurRadius: isSmallScreen ? 10 : 12,
                    offset: const Offset(0, 4),
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: iconInnerSize),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            // 文字内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: isSmallScreen ? 15 : 16,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 3 : 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: isSmallScreen ? 11 : 12,
                    ),
                  ),
                ],
              ),
            ),
            // 箭头按钮
            Container(
              width: arrowSize,
              height: arrowSize,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(isSmallScreen ? 9 : 10),
              ),
              child: Icon(
                Icons.chevron_right,
                color: AppColors.textLight,
                size: arrowIconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 应用信息卡片 - 渐变背景
  Widget _buildAppInfoCard(bool isSmallScreen) {
    final iconSize = isSmallScreen ? 64.0 : 72.0;
    final iconInnerSize = isSmallScreen ? 32.0 : 36.0;
    final padding = isSmallScreen ? 20.0 : 24.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: AppColors.sunsetGradient,
        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
        boxShadow: [
          BoxShadow(
            color: AppColors.pinkStart.withAlpha(128),
            blurRadius: isSmallScreen ? 16 : 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: AppColors.pinkEnd.withAlpha(77),
            blurRadius: isSmallScreen ? 24 : 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // 图标
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_fix_high,
              color: Colors.white,
              size: iconInnerSize,
            ),
          ),
          SizedBox(height: isSmallScreen ? 14 : 16),
          Text(
            'CP嗒啧',
            style: AppTextStyles.headline3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: isSmallScreen ? 16 : 18,
            ),
          ),
          SizedBox(height: isSmallScreen ? 3 : 4),
          Text(
            '版本 1.0.0',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withAlpha(204),
              fontSize: isSmallScreen ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  _SettingsItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
