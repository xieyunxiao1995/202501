import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/screens/explore/explore_screen.dart';
import 'package:zhenyu_flutter/screens/invate/invate_screen.dart';
import 'package:zhenyu_flutter/screens/message/message_screen.dart';
import 'package:zhenyu_flutter/screens/mine/mine_screen.dart';
import 'package:zhenyu_flutter/screens/people/people_screen.dart';
import 'package:zhenyu_flutter/services/im_manager.dart';
import 'package:zhenyu_flutter/shared/bottom_nav_icon.dart';
import 'package:zhenyu_flutter/theme.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int _currentIndex = 0;

  final List<_BottomNavInfo> _navInfoList = [
    _BottomNavInfo(
      page: const PeopleScreen(),
      label: '首页',
      normalIcon: 'assets/images/tabbars/explore_normal.png',
      selectedIcon: 'assets/images/tabbars/explore_selected.png',
    ),
    _BottomNavInfo(
      page: const ExploreScreen(),
      label: '动态',
      normalIcon: 'assets/images/tabbars/people_normal.png',
      selectedIcon: 'assets/images/tabbars/people_selected.png',
    ),
    _BottomNavInfo(
      page: const InvateScreen(),
      label: '邀请有礼',
      normalIcon: 'assets/images/tabbars/giftbox.png',
      selectedIcon: 'assets/images/tabbars/giftbox.png',
    ),
    _BottomNavInfo(
      page: const MessageScreen(),
      label: '消息',
      normalIcon: 'assets/images/tabbars/message_normal.png',
      selectedIcon: 'assets/images/tabbars/message_selected.png',
    ),
    _BottomNavInfo(
      page: const MineScreen(),
      label: '我的',
      normalIcon: 'assets/images/tabbars/mine_normal.png',
      selectedIcon: 'assets/images/tabbars/mine_selected.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final imManager = context.watch<ImManager>();

    return Scaffold(
      body: _navInfoList[_currentIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // 如果点击的是"邀请有礼"，跳转到新页面而不是切换 tab
          if (_navInfoList[index].label == '邀请有礼') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _navInfoList[index].page),
            );
          } else {
            // 其他 tab 正常切换
            setState(() => _currentIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.tabBarBackground,
        selectedItemColor: AppColors.secondaryGradientEnd,
        unselectedItemColor: AppColors.tabBarNormal,
        showUnselectedLabels: true,
        items: _navInfoList.asMap().entries.map((entry) {
          final index = entry.key;
          final navInfo = entry.value;
          final isInvite = navInfo.label == '邀请有礼';

          Widget icon;
          if (navInfo.label == '消息') {
            // 特殊处理消息图标的未读数
            icon = ValueListenableBuilder<int>(
              valueListenable: imManager.unreadCount,
              builder: (context, unreadCount, child) {
                return BottomNavIcon(
                  normalImagePath: navInfo.normalIcon,
                  selectedImagePath: navInfo.selectedIcon,
                  isSelected: _currentIndex == index,
                  badgeCount: unreadCount,
                );
              },
            );
          } else if (isInvite) {
            // 邀请有礼：使用 Transform 向上移动，确保图标对齐
            icon = Transform.translate(
              offset: const Offset(0, 11), // 向上移动 6 像素
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomNavIcon(
                    normalImagePath: navInfo.normalIcon,
                    selectedImagePath: navInfo.selectedIcon,
                    isSelected: _currentIndex == index,
                    isSpecial: true,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    navInfo.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryGradientEnd, // 永远高亮
                    ),
                  ),
                ],
              ),
            );
          } else {
            icon = BottomNavIcon(
              normalImagePath: navInfo.normalIcon,
              selectedImagePath: navInfo.selectedIcon,
              isSelected: _currentIndex == index,
            );
          }

          return BottomNavigationBarItem(
            icon: icon,
            label: isInvite
                ? ''
                : navInfo.label, // 邀请有礼的 label 为空，因为已经在 icon 中显示了
          );
        }).toList(),
      ),
    );
  }
}

class _BottomNavInfo {
  final Widget page;
  final String label;
  final String normalIcon;
  final String selectedIcon;

  _BottomNavInfo({
    required this.page,
    required this.label,
    required this.normalIcon,
    required this.selectedIcon,
  });
}
