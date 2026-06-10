import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/route_paths.dart';

/// 建筑数据
class _Building {
  const _Building({
    required this.name,
    required this.icon,
    required this.func,
    required this.route,
  });

  final String name;
  final IconData icon;
  final String func;
  final String route;
}

/// 主城建筑列表
const _kBuildings = <_Building>[
  _Building(
    name: '主公府',
    icon: Icons.account_balance,
    func: '主城等级',
    route: RoutePaths.lordMansion,
  ),
  _Building(
    name: '校场',
    icon: Icons.fitness_center,
    func: '训练士兵',
    route: RoutePaths.trainingGround,
  ),
  _Building(
    name: '议事厅',
    icon: Icons.assignment,
    func: '接取任务',
    route: RoutePaths.councilHall,
  ),
  _Building(
    name: '武器坊',
    icon: Icons.build_circle,
    func: '打造装备',
    route: RoutePaths.weaponWorkshop,
  ),
  _Building(
    name: '马厩',
    icon: Icons.nature_people,
    func: '培养战马',
    route: RoutePaths.stable,
  ),
  _Building(
    name: '酒馆',
    icon: Icons.local_bar,
    func: '招募武将',
    route: RoutePaths.tavern,
  ),
  _Building(
    name: '粮仓',
    icon: Icons.grass,
    func: '储存粮食',
    route: RoutePaths.granary,
  ),
  _Building(
    name: '铸币司',
    icon: Icons.monetization_on,
    func: '产出金币',
    route: RoutePaths.mint,
  ),
  _Building(
    name: '学堂',
    icon: Icons.menu_book,
    func: '研究战法',
    route: RoutePaths.academy,
  ),
  _Building(
    name: '观星台',
    icon: Icons.auto_awesome,
    func: '占卜抽奖',
    route: RoutePaths.observatory,
  ),
  _Building(
    name: '演武场',
    icon: Icons.sports_kabaddi,
    func: '竞技 PVP',
    route: RoutePaths.cityArena,
  ),
];

/// 主城页面
///
/// 底部导航栏"主页"标签对应的界面。
/// 上半部分为建筑功能入口网格，下半部分展示主城背景。
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
          child: Column(
            children: [
              // ---- 个人中心入口 ----
              const _PersonalCenterBar(),

              const SizedBox(height: 4),

              // ---- 建筑入口网格 ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _BuildingGrid(buildings: _kBuildings),
              ),

              // 下半部分留白，展示主城背景
              const Spacer(),

              // ---- 底部功能入口占位 ----
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 建筑网格 ====================

class _BuildingGrid extends StatelessWidget {
  const _BuildingGrid({required this.buildings});

  final List<_Building> buildings;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 一行显示 4 个，计算每个格子的宽度
        final crossAxisCount = 4;
        final spacing = 6.0;
        final totalSpacing = spacing * (crossAxisCount + 1);
        final itemWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: buildings.map((b) {
            return SizedBox(
              width: itemWidth,
              child: _BuildingItem(building: b),
            );
          }).toList(),
        );
      },
    );
  }
}

// ==================== 单个建筑入口 ====================

class _BuildingItem extends StatelessWidget {
  const _BuildingItem({required this.building});

  final _Building building;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _onTap(context),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xCC1A1A2A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x306A0F0F), width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图标
              Icon(building.icon, size: 26, color: const Color(0xFFD4A84B)),
              const SizedBox(height: 6),
              // 建筑名
              Text(
                building.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE2D9CD),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              // 功能描述
              Text(
                building.func,
                style: const TextStyle(fontSize: 10, color: Color(0x998B7E6A)),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final rect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    context.push(building.route, extra: rect);
  }
}

// ==================== 个人中心入口 ====================

/// 左上角个人中心入口
///
/// 显示角色头像、等级、关卡进度等信息。
/// 点击可跳转到个人中心详情页。
class _PersonalCenterBar extends StatelessWidget {
  const _PersonalCenterBar();

  /// 模拟数据 — 后续替换为实际数据源
  static const _playerLevel = 1;
  static const _chapterName = '第1章';
  static const _playerName = '主公';

  void _onTap(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final rect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    context.push(RoutePaths.personal, extra: rect);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          // ---- 个人中心按钮 ----
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () => _onTap(context),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 14,
                  top: 6,
                  bottom: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xCC1A1A2A),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0x306A0F0F),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 头像
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: const Color(0x406A0F0F),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFD4A84B),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 名字 + 等级
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 玩家名
                        Text(
                          _playerName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE2D9CD),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // 等级 + 关卡进度
                        Row(
                          children: [
                            _InfoTag(
                              icon: Icons.star,
                              text: 'Lv.$_playerLevel',
                            ),
                            const SizedBox(width: 6),
                            _InfoTag(icon: Icons.map, text: _chapterName),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          // ---- 右侧资源栏占位 ----
        ],
      ),
    );
  }
}

/// 信息标签
///
/// 用于显示等级、关卡等短信息，带图标前缀。
class _InfoTag extends StatelessWidget {
  const _InfoTag({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: const Color(0xFFD4A84B)),
        const SizedBox(width: 2),
        Text(
          text,
          style: const TextStyle(fontSize: 10, color: Color(0x998B7E6A)),
        ),
      ],
    );
  }
}
