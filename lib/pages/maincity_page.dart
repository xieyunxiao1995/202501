import 'package:flutter/material.dart';

/// 主城页面
///
/// 底部导航栏"主页"标签对应的界面。
/// 以主城背景图铺满全屏，后续可叠加建筑、资源等交互元素。
class MainCityPage extends StatelessWidget {
  const MainCityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/maincity_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 背景层已由 DecoratedBox 提供

              // TODO: 在此叠加主城建筑、资源栏、功能入口等交互元素
            ],
          ),
        ),
      ),
    );
  }
}
