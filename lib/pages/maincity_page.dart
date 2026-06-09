import 'package:flutter/material.dart';

/// 建筑数据
class _Building {
  const _Building({
    required this.name,
    required this.icon,
    required this.func,
    this.route,
  });

  final String name;
  final IconData icon;
  final String func;
  final String? route; // 预留：后续用于路由跳转
}

/// 主城建筑列表
const _kBuildings = <_Building>[
  _Building(name: '主公府', icon: Icons.account_balance, func: '主城等级'),
  _Building(name: '校场', icon: Icons.fitness_center, func: '训练士兵'),
  _Building(name: '议事厅', icon: Icons.assignment, func: '接取任务'),
  _Building(name: '武器坊', icon: Icons.build_circle, func: '打造装备'),
  _Building(name: '马厩', icon: Icons.nature_people, func: '培养战马'),
  _Building(name: '酒馆', icon: Icons.local_bar, func: '招募武将'),
  _Building(name: '粮仓', icon: Icons.grass, func: '储存粮食'),
  _Building(name: '铸币司', icon: Icons.monetization_on, func: '产出金币'),
  _Building(name: '学堂', icon: Icons.menu_book, func: '研究战法'),
  _Building(name: '观星台', icon: Icons.auto_awesome, func: '占卜抽奖'),
  _Building(name: '演武场', icon: Icons.sports_kabaddi, func: '竞技 PVP'),
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
              // ---- 顶部资源栏占位（后续添加） ----
              const SizedBox(height: 8),

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
        final itemWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

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
            border: Border.all(
              color: const Color(0x306A0F0F),
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图标
              Icon(
                building.icon,
                size: 26,
                color: const Color(0xFFD4A84B),
              ),
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
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0x998B7E6A),
                ),
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
    // TODO: 根据 building.route 跳转到对应功能页面
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${building.name} — 即将开放'),
          duration: const Duration(seconds: 1),
        ),
      );
  }
}

