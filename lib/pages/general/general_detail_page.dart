import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/general/general_model.dart';
import '../../data/models/general/skill_model.dart';
import '../../data/models/general/equipment_model.dart';

/// 武将详情页
///
/// 展示武将立绘、基础属性、技能装备等信息。
/// 通过路由参数 `:id` 获取武将 ID，匹配对应的武将数据。
class GeneralDetailPage extends StatefulWidget {
  const GeneralDetailPage({super.key, required this.generalId});

  /// 武将 ID（从路由参数获取）
  final String generalId;

  @override
  State<GeneralDetailPage> createState() => _GeneralDetailPageState();
}

class _GeneralDetailPageState extends State<GeneralDetailPage> {
  late final GeneralModel _general;
  late final List<SkillModel> _skills;
  late final EquipmentModel? _equipment;

  @override
  void initState() {
    super.initState();
    _general = _mockGenerals.firstWhere(
      (g) => g.id == widget.generalId,
      orElse: () => _mockGenerals.first,
    );
    _skills = _mockSkills[widget.generalId] ?? [];
    _equipment = _mockEquipment[widget.generalId];
  }

  @override
  Widget build(BuildContext context) {
    final rarityInfo = _Rarity.get(_general.rarity);
    final kingdomInfo = _Kingdom.get(_general.kingdom);
    final professionInfo = _Profession.get(_general.profession);

    return Scaffold(
      backgroundColor: const Color(0xFF120D0D),
      body: CustomScrollView(
        slivers: [
          // ---- 立绘区域 ----
          _PortraitHeader(general: _general, rarityInfo: rarityInfo),

          // ---- 信息区域 ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 名称 + 稀有度
                  _NameSection(general: _general, rarityInfo: rarityInfo),
                  const SizedBox(height: 10),

                  // 阵营 + 职业
                  Row(
                    children: [
                      _Tag(label: kingdomInfo.label, color: kingdomInfo.color),
                      const SizedBox(width: 8),
                      _Tag(
                        label: professionInfo.label,
                        color: professionInfo.color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 星级 + 等级 + 战力
                  _StarLevelPower(general: _general),
                  const SizedBox(height: 20),

                  // ---- 基础属性 ----
                  const _SectionTitle(title: '基础属性'),
                  const SizedBox(height: 10),
                  _StatsGrid(general: _general),
                  const SizedBox(height: 24),

                  // ---- 技能 ----
                  const _SectionTitle(title: '技能'),
                  const SizedBox(height: 10),
                  ..._skills.map(
                    (skill) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _SkillCard(skill: skill),
                    ),
                  ),
                  if (_skills.isEmpty)
                    const _EmptyHint(text: '暂无技能数据'),
                  const SizedBox(height: 24),

                  // ---- 装备 ----
                  const _SectionTitle(title: '装备'),
                  const SizedBox(height: 10),
                  if (_equipment != null)
                    _EquipmentCard(equipment: _equipment!)
                  else
                    const _EmptyHint(text: '暂无装备'),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Mock 数据 ====================

  static const _mockGenerals = [
    GeneralModel(
      id: '1', name: '吕布', kingdom: 'qun', profession: 'berserker',
      rarity: 'ssr', star: 5, level: 60,
      atk: 980, def: 420, hp: 8500, spd: 88, power: 28500,
    ),
    GeneralModel(
      id: '2', name: '关羽', kingdom: 'shu', profession: 'berserker',
      rarity: 'ssr', star: 5, level: 55,
      atk: 920, def: 510, hp: 9200, spd: 72, power: 26800,
    ),
    GeneralModel(
      id: '3', name: '诸葛亮', kingdom: 'shu', profession: 'strategist',
      rarity: 'ssr', star: 5, level: 58,
      atk: 680, def: 380, hp: 7200, spd: 65, power: 25200,
    ),
    GeneralModel(
      id: '4', name: '曹操', kingdom: 'wei', profession: 'strategist',
      rarity: 'ssr', star: 5, level: 60,
      atk: 750, def: 550, hp: 8800, spd: 70, power: 27800,
    ),
    GeneralModel(
      id: '5', name: '赵云', kingdom: 'shu', profession: 'assassin',
      rarity: 'ssr', star: 4, level: 52,
      atk: 860, def: 450, hp: 7800, spd: 95, power: 24500,
    ),
    GeneralModel(
      id: '6', name: '周瑜', kingdom: 'wu', profession: 'strategist',
      rarity: 'ssr', star: 4, level: 50,
      atk: 720, def: 400, hp: 7400, spd: 68, power: 23800,
    ),
    GeneralModel(
      id: '7', name: '司马懿', kingdom: 'wei', profession: 'trickster',
      rarity: 'ssr', star: 5, level: 56,
      atk: 700, def: 480, hp: 8200, spd: 62, power: 26000,
    ),
    GeneralModel(
      id: '8', name: '孙尚香', kingdom: 'wu', profession: 'assassin',
      rarity: 'sr', star: 4, level: 48,
      atk: 780, def: 350, hp: 6800, spd: 90, power: 21500,
    ),
    GeneralModel(
      id: '9', name: '张飞', kingdom: 'shu', profession: 'guardian',
      rarity: 'ssr', star: 4, level: 50,
      atk: 850, def: 650, hp: 10500, spd: 55, power: 25500,
    ),
    GeneralModel(
      id: '10', name: '貂蝉', kingdom: 'qun', profession: 'support',
      rarity: 'sr', star: 3, level: 45,
      atk: 480, def: 320, hp: 6200, spd: 78, power: 19200,
    ),
    GeneralModel(
      id: '11', name: '夏侯惇', kingdom: 'wei', profession: 'guardian',
      rarity: 'sr', star: 3, level: 42,
      atk: 720, def: 580, hp: 9500, spd: 58, power: 20800,
    ),
    GeneralModel(
      id: '12', name: '陆逊', kingdom: 'wu', profession: 'strategist',
      rarity: 'sr', star: 3, level: 44,
      atk: 650, def: 420, hp: 7000, spd: 60, power: 20000,
    ),
  ];

  static const _mockSkills = {
    '1': [
      SkillModel(
        id: 's1', name: '方天画戟', type: 'ultimate',
        description: '对敌方单体造成 240% 伤害，若击杀目标则追加一次普攻',
        damageMultiplier: 2.4, rageCost: 100, targetCount: 1, level: 3,
      ),
      SkillModel(
        id: 's2', name: '无双', type: 'active',
        description: '对随机 3 名敌人造成 120% 伤害',
        damageMultiplier: 1.2, rageCost: 0, targetCount: 3, level: 2,
      ),
      SkillModel(
        id: 's3', name: '飞将', type: 'passive',
        description: '暴击率提升 15%，暴击伤害提升 30%',
        damageMultiplier: 0, rageCost: 0, targetCount: 0, level: 1,
      ),
    ],
    '3': [
      SkillModel(
        id: 's4', name: '神算鬼谋', type: 'ultimate',
        description: '对敌方全体造成 180% 伤害，附加灼烧效果',
        damageMultiplier: 1.8, rageCost: 100, targetCount: 5, level: 3,
      ),
      SkillModel(
        id: 's5', name: '八阵图', type: 'active',
        description: '为友方全体增加 20% 防御，持续 2 回合',
        damageMultiplier: 0, rageCost: 0, targetCount: 6, level: 2,
      ),
    ],
    '5': [
      SkillModel(
        id: 's6', name: '七进七出', type: 'ultimate',
        description: '对敌方单体造成 280% 伤害，自身闪避率提升 50% 持续 1 回合',
        damageMultiplier: 2.8, rageCost: 100, targetCount: 1, level: 3,
      ),
    ],
  };

  static const _mockEquipment = {
    '1': EquipmentModel(
      id: 'e1', name: '兽面吞头铠', type: 'armor', rarity: 'ssr',
      atk: 80, def: 120, hp: 500, spd: 10, level: 5,
    ),
    '2': EquipmentModel(
      id: 'e2', name: '青龙战甲', type: 'armor', rarity: 'ssr',
      atk: 60, def: 150, hp: 800, spd: 5, level: 4,
    ),
  };
}

// ==================== 立绘头部 ====================

/// 立绘展示区域
///
/// 渐变背景 + 武将立绘占位 + 顶部导航栏。
class _PortraitHeader extends StatelessWidget {
  const _PortraitHeader({
    required this.general,
    required this.rarityInfo,
  });

  final GeneralModel general;
  final _Rarity rarityInfo;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 280,
      backgroundColor: const Color(0xFF1A1111),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 背景渐变
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    rarityInfo.color.withOpacity(0.2),
                    const Color(0xFF120D0D),
                  ],
                ),
              ),
            ),
            // 立绘占位
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: rarityInfo.color.withOpacity(0.15),
                      border: Border.all(
                        color: rarityInfo.color.withOpacity(0.4),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: rarityInfo.color.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        general.name,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: rarityInfo.color.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '武将立绘',
                    style: TextStyle(
                      fontSize: 11,
                      color: rarityInfo.color.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        color: const Color(0xFFE2D9CD),
        onPressed: () => context.pop(),
      ),
    );
  }
}

// ==================== 名称区域 ====================

/// 武将名称 + 稀有度标签
class _NameSection extends StatelessWidget {
  const _NameSection({required this.general, required this.rarityInfo});

  final GeneralModel general;
  final _Rarity rarityInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          general.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE2D9CD),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: rarityInfo.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: rarityInfo.color.withOpacity(0.4)),
          ),
          child: Text(
            rarityInfo.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: rarityInfo.color,
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== 星级/等级/战力 ====================

/// 星级 + 等级 + 战力行
class _StarLevelPower extends StatelessWidget {
  const _StarLevelPower({required this.general});

  final GeneralModel general;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 星级
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            general.star,
            (_) => const Padding(
              padding: EdgeInsets.only(right: 2),
              child: Icon(Icons.star, size: 16, color: Color(0xFFD4A017)),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // 等级
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0x18FFFFFF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Lv.${general.level}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B7E6A),
            ),
          ),
        ),
        const Spacer(),

        // 战力
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              '战力',
              style: TextStyle(fontSize: 11, color: Color(0x668B7E6A)),
            ),
            Text(
              _formatPower(general.power),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE2D9CD),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatPower(int power) {
    if (power >= 10000) {
      return '${(power / 10000).toStringAsFixed(1)}万';
    }
    return power.toString();
  }
}

// ==================== 基础属性网格 ====================

/// 基础属性四宫格 (ATK / DEF / HP / SPD)
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.general});

  final GeneralModel general;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 3.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatTile(label: '攻击', value: general.atk.toString(), icon: '⚔️'),
        _StatTile(label: '防御', value: general.def.toString(), icon: '🛡️'),
        _StatTile(label: '生命', value: general.hp.toString(), icon: '❤️'),
        _StatTile(label: '速度', value: general.spd.toString(), icon: '💨'),
      ],
    );
  }
}

/// 单个属性格子
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1111),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x206A0F0F)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0x998B7E6A)),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE2D9CD),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 技能卡片 ====================

/// 技能卡片
class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill});

  final SkillModel skill;

  static const _typeLabels = {
    'ultimate': '大招',
    'active': '主动',
    'passive': '被动',
    'normal': '普攻',
  };

  static const _typeColors = {
    'ultimate': Color(0xFFE14F4F),
    'active': Color(0xFFD4A017),
    'passive': Color(0xFF4A90D9),
    'normal': Color(0xFF8B8B8B),
  };

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColors[skill.type] ?? const Color(0xFF8B8B8B);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1111),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x206A0F0F)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                skill.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE2D9CD),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  _typeLabels[skill.type] ?? skill.type,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: typeColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Lv.${skill.level}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0x998B7E6A),
                ),
              ),
            ],
          ),
          if (skill.description != null) ...[
            const SizedBox(height: 6),
            Text(
              skill.description!,
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Color(0x998B7E6A),
              ),
            ),
          ],
          if (skill.damageMultiplier > 0) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                _SkillStat(label: '伤害', value: '${(skill.damageMultiplier * 100).toInt()}%'),
                const SizedBox(width: 12),
                if (skill.rageCost > 0)
                  _SkillStat(label: '怒气', value: '${skill.rageCost}'),
                const SizedBox(width: 12),
                _SkillStat(label: '目标', value: '${skill.targetCount}人'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 技能数值标签
class _SkillStat extends StatelessWidget {
  const _SkillStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label ',
          style: const TextStyle(fontSize: 11, color: Color(0x558B7E6A)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD4A017),
          ),
        ),
      ],
    );
  }
}

// ==================== 装备卡片 ====================

/// 装备卡片
class _EquipmentCard extends StatelessWidget {
  const _EquipmentCard({required this.equipment});

  final EquipmentModel equipment;

  @override
  Widget build(BuildContext context) {
    final rarityInfo = _Rarity.get(equipment.rarity);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1111),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: rarityInfo.color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // 装备图标占位
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: rarityInfo.color.withOpacity(0.12),
              border: Border.all(color: rarityInfo.color.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                '🛡️',
                style: TextStyle(fontSize: 20, color: rarityInfo.color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      equipment.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE2D9CD),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      rarityInfo.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: rarityInfo.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'ATK+${equipment.atk}  DEF+${equipment.def}  HP+${equipment.hp}',
                  style: const TextStyle(fontSize: 11, color: Color(0x778B7E6A)),
                ),
              ],
            ),
          ),
          Text(
            'Lv.${equipment.level}',
            style: const TextStyle(fontSize: 12, color: Color(0x998B7E6A)),
          ),
        ],
      ),
    );
  }
}

// ==================== 通用组件 ====================

/// 区块标题
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: const BoxDecoration(
            color: Color(0xFFA11717),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE2D9CD),
          ),
        ),
      ],
    );
  }
}

/// 空数据提示
class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1111),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x156A0F0F)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, color: Color(0x558B7E6A)),
        ),
      ),
    );
  }
}

/// 小标签
class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withOpacity(0.25), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: color.withOpacity(0.9)),
      ),
    );
  }
}

// ==================== 配置 ====================

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
  };
  static _Kingdom get(String key) =>
      _map[key] ?? const _Kingdom._(label: '?', color: Color(0xFF8B8B8B));
}

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
