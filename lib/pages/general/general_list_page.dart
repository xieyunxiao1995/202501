import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_paths.dart';
import '../../data/models/general/general_model.dart';

/// 武将列表页
///
/// 以网格形式展示所有武将，支持点击查看详情。
/// 每个卡片显示武将头像、名称、稀有度、阵营、职业、星级和战力。
class GeneralListPage extends StatefulWidget {
  const GeneralListPage({super.key});

  @override
  State<GeneralListPage> createState() => _GeneralListPageState();
}

class _GeneralListPageState extends State<GeneralListPage> {
  /// 模拟武将数据（后续接入 API / datasource）
  static const _mockGenerals = [
    GeneralModel(
      id: '1',
      name: '吕布',
      kingdom: 'qun',
      profession: 'berserker',
      rarity: 'ssr',
      star: 5,
      level: 60,
      atk: 980,
      def: 420,
      hp: 8500,
      spd: 88,
      power: 28500,
    ),
    GeneralModel(
      id: '2',
      name: '关羽',
      kingdom: 'shu',
      profession: 'berserker',
      rarity: 'ssr',
      star: 5,
      level: 55,
      atk: 920,
      def: 510,
      hp: 9200,
      spd: 72,
      power: 26800,
    ),
    GeneralModel(
      id: '3',
      name: '诸葛亮',
      kingdom: 'shu',
      profession: 'strategist',
      rarity: 'ssr',
      star: 5,
      level: 58,
      atk: 680,
      def: 380,
      hp: 7200,
      spd: 65,
      power: 25200,
    ),
    GeneralModel(
      id: '4',
      name: '曹操',
      kingdom: 'wei',
      profession: 'strategist',
      rarity: 'ssr',
      star: 5,
      level: 60,
      atk: 750,
      def: 550,
      hp: 8800,
      spd: 70,
      power: 27800,
    ),
    GeneralModel(
      id: '5',
      name: '赵云',
      kingdom: 'shu',
      profession: 'assassin',
      rarity: 'ssr',
      star: 4,
      level: 52,
      atk: 860,
      def: 450,
      hp: 7800,
      spd: 95,
      power: 24500,
    ),
    GeneralModel(
      id: '6',
      name: '周瑜',
      kingdom: 'wu',
      profession: 'strategist',
      rarity: 'ssr',
      star: 4,
      level: 50,
      atk: 720,
      def: 400,
      hp: 7400,
      spd: 68,
      power: 23800,
    ),
    GeneralModel(
      id: '7',
      name: '司马懿',
      kingdom: 'wei',
      profession: 'trickster',
      rarity: 'ssr',
      star: 5,
      level: 56,
      atk: 700,
      def: 480,
      hp: 8200,
      spd: 62,
      power: 26000,
    ),
    GeneralModel(
      id: '8',
      name: '孙尚香',
      kingdom: 'wu',
      profession: 'assassin',
      rarity: 'sr',
      star: 4,
      level: 48,
      atk: 780,
      def: 350,
      hp: 6800,
      spd: 90,
      power: 21500,
    ),
    GeneralModel(
      id: '9',
      name: '张飞',
      kingdom: 'shu',
      profession: 'guardian',
      rarity: 'ssr',
      star: 4,
      level: 50,
      atk: 850,
      def: 650,
      hp: 10500,
      spd: 55,
      power: 25500,
    ),
    GeneralModel(
      id: '10',
      name: '貂蝉',
      kingdom: 'qun',
      profession: 'support',
      rarity: 'sr',
      star: 3,
      level: 45,
      atk: 480,
      def: 320,
      hp: 6200,
      spd: 78,
      power: 19200,
    ),
    GeneralModel(
      id: '11',
      name: '夏侯惇',
      kingdom: 'wei',
      profession: 'guardian',
      rarity: 'sr',
      star: 3,
      level: 42,
      atk: 720,
      def: 580,
      hp: 9500,
      spd: 58,
      power: 20800,
    ),
    GeneralModel(
      id: '12',
      name: '陆逊',
      kingdom: 'wu',
      profession: 'strategist',
      rarity: 'sr',
      star: 3,
      level: 44,
      atk: 650,
      def: 420,
      hp: 7000,
      spd: 60,
      power: 20000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120D0D),
      appBar: AppBar(
        title: const Text(
          '武将',
          style: TextStyle(
            color: Color(0xFFE2D9CD),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: _mockGenerals.length,
        itemBuilder: (context, index) {
          final general = _mockGenerals[index];
          return _GeneralCard(
            general: general,
            onTap: () {
              context.push('${RoutePaths.generalList}/${general.id}');
            },
          );
        },
      ),
    );
  }
}

// ==================== 武将卡片 ====================

/// 武将展示卡片
///
/// 暗色背景卡片，展示武将头像、名称、稀有度框、
/// 阵营/职业标签、星级、等级和战力。
class _GeneralCard extends StatelessWidget {
  const _GeneralCard({required this.general, required this.onTap});

  final GeneralModel general;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rarityInfo = _Rarity.get(general.rarity);
    final kingdomInfo = _Kingdom.get(general.kingdom);
    final professionInfo = _Profession.get(general.profession);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1111),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: rarityInfo.color.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- 头像区 ----
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 背景光晕
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(9),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            rarityInfo.color.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 头像占位
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: rarityInfo.color.withOpacity(0.12),
                        border: Border.all(
                          color: rarityInfo.color.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          general.name.characters.first,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: rarityInfo.color.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 稀有度标签
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: rarityInfo.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: rarityInfo.color.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        rarityInfo.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: rarityInfo.color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---- 信息区 ----
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0x206A0F0F)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 名称
                  Text(
                    general.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE2D9CD),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 阵营 & 职业
                  Row(
                    children: [
                      _Tag(
                        label: kingdomInfo.label,
                        color: kingdomInfo.color,
                      ),
                      const SizedBox(width: 4),
                      _Tag(
                        label: professionInfo.label,
                        color: professionInfo.color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // 星级 + 等级
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 星级
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          general.star,
                          (_) => const Icon(
                            Icons.star,
                            size: 11,
                            color: Color(0xFFD4A017),
                          ),
                        ),
                      ),
                      // 等级 & 战力
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Lv.${general.level}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0x998B7E6A),
                            ),
                          ),
                          Text(
                            _formatPower(general.power),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0x668B7E6A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 格式化战力（万为单位）
  String _formatPower(int power) {
    if (power >= 10000) {
      return '${(power / 10000).toStringAsFixed(1)}万';
    }
    return power.toString();
  }
}

// ==================== 标签组件 ====================

/// 小标签（阵营、职业）
class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: color.withOpacity(0.85)),
      ),
    );
  }
}

// ==================== 配置数据 ====================

/// 稀有度配置
class _Rarity {
  const _Rarity._({required this.label, required this.color});

  final String label;
  final Color color;

  static const _map = {
    'n': _Rarity._(label: 'N', color: Color(0xFF8B8B8B)),
    'r': _Rarity._(label: 'R', color: Color(0xFF4A90D9)),
    'sr': _Rarity._(label: 'SR', color: Color(0xFF9B59B6)),
    'ssr': _Rarity._(label: 'SSR', color: Color(0xFFE8A317)),
    'ur': _Rarity._(label: 'UR', color: Color(0xFFE14F4F)),
    'legendary': _Rarity._(label: '传说', color: Color(0xFFFF6B35)),
  };

  static _Rarity get(String key) =>
      _map[key] ?? const _Rarity._(label: '?', color: Color(0xFF8B8B8B));
}

/// 阵营配置
class _Kingdom {
  const _Kingdom._({required this.label, required this.color});

  final String label;
  final Color color;

  static const _map = {
    'wei': _Kingdom._(label: '魏', color: Color(0xFF4A90D9)),
    'shu': _Kingdom._(label: '蜀', color: Color(0xFF27AE60)),
    'wu': _Kingdom._(label: '吴', color: Color(0xFFE14F4F)),
    'qun': _Kingdom._(label: '群', color: Color(0xFF9B59B6)),
    'jin': _Kingdom._(label: '晋', color: Color(0xFF8B7E6A)),
    'female': _Kingdom._(label: '女', color: Color(0xFFE91E8F)),
  };

  static _Kingdom get(String key) =>
      _map[key] ?? const _Kingdom._(label: '?', color: Color(0xFF8B8B8B));
}

/// 职业配置
class _Profession {
  const _Profession._({required this.label, required this.color});

  final String label;
  final Color color;

  static const _map = {
    'berserker': _Profession._(label: '猛将', color: Color(0xFFE14F4F)),
    'guardian': _Profession._(label: '守护', color: Color(0xFF4A90D9)),
    'warSage': _Profession._(label: '武圣', color: Color(0xFFD4A017)),
    'assassin': _Profession._(label: '刺客', color: Color(0xFF9B59B6)),
    'strategist': _Profession._(label: '谋士', color: Color(0xFF27AE60)),
    'support': _Profession._(label: '辅助', color: Color(0xFFE91E8F)),
    'trickster': _Profession._(label: '诡将', color: Color(0xFFFF6B35)),
  };

  static _Profession get(String key) =>
      _map[key] ?? const _Profession._(label: '?', color: Color(0xFF8B8B8B));
}
