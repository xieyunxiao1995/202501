import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'gallery_screen.dart';
import 'new_repair_screen.dart';
import 'ai_chat_screen.dart';
import 'settings_screen.dart';

/// 主导航页面 - 深色霓虹风格
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<GalleryScreenState> _galleryKey = GlobalKey();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      GalleryScreen(key: _galleryKey),
      const NewRepairScreen(),
      const AIChatScreen(),
      const SettingsScreen(),
    ];
  }

  final List<_NavItemData> _navItems = [
    _NavItemData(
      icon: Icons.photo_library_outlined,
      activeIcon: Icons.photo_library,
      label: '画廊',
      gradient: AppColors.pinkGradient,
    ),
    _NavItemData(
      icon: Icons.add_photo_alternate_outlined,
      activeIcon: Icons.add_photo_alternate,
      label: '新建',
      gradient: AppColors.orangeGradient,
    ),
    _NavItemData(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: '聊天',
      gradient: AppColors.purpleGradient,
    ),
    _NavItemData(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: '设置',
      gradient: AppColors.cyanGradient,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /// 底部导航栏 - 深色悬浮风格
  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          // 悬浮阴影
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
          // 顶部微光
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 30,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              return _buildNavItem(index: entry.key, data: entry.value);
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// 导航项 - 霓虹发光效果
  Widget _buildNavItem({required int index, required _NavItemData data}) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        // 如果从新建页面切换到画廊页面，刷新画廊数据
        if (_currentIndex == 1 && index == 0) {
          _galleryKey.currentState?.refresh();
        }
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isActive
            ? BoxDecoration(
                gradient: data.gradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  // 选中状态发光
                  BoxShadow(
                    color: data.gradient.colors.first.withAlpha(179),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                    spreadRadius: -4,
                  ),
                  // 弥散光晕
                  BoxShadow(
                    color: data.gradient.colors.last.withAlpha(77),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              )
            : const BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: isActive ? const EdgeInsets.all(4) : EdgeInsets.zero,
              decoration: isActive
                  ? BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Icon(
                isActive ? data.activeIcon : data.icon,
                color: isActive ? Colors.white : AppColors.textLight,
                size: isActive ? 26 : 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              data.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? Colors.white : AppColors.textLight,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final LinearGradient gradient;

  _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.gradient,
  });
}
