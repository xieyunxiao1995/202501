import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Custom bottom navigation bar with center FAB
class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.bottomNavHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              0,
              Icons.explore_outlined,
              Icons.explore,
              '发现',
            ),
            _buildNavItem(1, Icons.map_outlined, Icons.map, '计划'),
            _buildCenterFAB(),
            _buildNavItem(3, Icons.forum_outlined, Icons.forum, '社区'),
            _buildNavItem(4, Icons.person_outline, Icons.person, '我的'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isActive = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: AppConstants.iconSizeLarge,
              color: isActive ? AppConstants.primaryColor : Colors.grey[400],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.fontSizeCaption,
                color: isActive ? AppConstants.primaryColor : Colors.grey[400],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterFAB() {
    final isActive = currentIndex == 2;
    return Container(
      width: 56,
      height: 56,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppConstants.accentColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppConstants.accentColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(2),
          customBorder: const CircleBorder(),
          child: Icon(Icons.add, color: Colors.white, size: isActive ? 32 : 28),
        ),
      ),
    );
  }
}
