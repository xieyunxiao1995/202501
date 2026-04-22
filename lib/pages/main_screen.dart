import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme.dart';
import 'home_page.dart';
import 'community_page.dart';
import 'stylist_page.dart';
import 'profile_page.dart';
import '../utils/responsive_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CommunityPage(),
    const StylistPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.getScaleFactor(context);
    final padding = ResponsiveHelper.responsivePadding(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundLight,
              const Color(0xFFF8F6FF),
              const Color(0xFFF3E8FF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, 8 * scale, padding, 12 * scale),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: '首页',
                  isActive: _currentIndex == 0,
                  activeGradient: const [
                    AppColors.gradientPurpleStart,
                    AppColors.gradientPurpleEnd,
                  ],
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.diversity_3_outlined,
                  activeIcon: Icons.diversity_3_rounded,
                  label: '穿搭创意',
                  isActive: _currentIndex == 1,
                  activeGradient: const [
                    AppColors.gradientPinkStart,
                    AppColors.gradientPinkEnd,
                  ],
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.checkroom_outlined,
                  activeIcon: Icons.checkroom_rounded,
                  label: '小搭',
                  isActive: _currentIndex == 2,
                  activeGradient: const [
                    AppColors.gradientTealStart,
                    AppColors.gradientTealEnd,
                  ],
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person_rounded,
                  label: '我的',
                  isActive: _currentIndex == 3,
                  activeGradient: const [
                    AppColors.gradientOrangeStart,
                    AppColors.gradientOrangeEnd,
                  ],
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final List<Color> activeGradient;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeGradient,
  });

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.getScaleFactor(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 8 * scale),
        decoration: BoxDecoration(
          gradient: isActive ? LinearGradient(colors: activeGradient) : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeGradient[0].withOpacity(0.3),
                    blurRadius: 12 * scale,
                    offset: Offset(0, 3 * scale),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? Colors.white : Colors.grey.shade500,
                size: 24 * scale,
              ),
            ),
            SizedBox(height: 5 * scale),
            Text(
              label,
              style: TextStyle(
                fontSize: 11 * scale,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? Colors.white : Colors.grey.shade500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
