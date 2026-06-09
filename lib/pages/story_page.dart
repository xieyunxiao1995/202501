import 'package:flutter/material.dart';

/// 剧情页面
///
/// 底部导航栏"剧情"标签对应的界面。
/// 以剧情背景图铺满全屏，后续可叠加章节选择、关卡入口等交互元素。
class StoryPage extends StatelessWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/story_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 背景层已由 DecoratedBox 提供

              // TODO: 在此叠加章节列表、关卡入口、剧情进度等交互元素
            ],
          ),
        ),
      ),
    );
  }
}
