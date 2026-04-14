import 'package:flutter/material.dart';

/// 角色升级页面
class CharacterUpgradeScreen extends StatefulWidget {
  const CharacterUpgradeScreen({super.key});

  @override
  State<CharacterUpgradeScreen> createState() => _CharacterUpgradeScreenState();
}

class _CharacterUpgradeScreenState extends State<CharacterUpgradeScreen>
    with SingleTickerProviderStateMixin {
  int _stardust = 1250; // 当前星尘数量

  final List<CharacterAttribute> _attributes = [
    CharacterAttribute(
      id: 'hp',
      name: '基地生命',
      description: '提升基地的最大生命值',
      icon: '❤️',
      level: 5,
      maxLevel: 20,
      baseHp: 100,
      hpPerLevel: 20,
      upgradeCost: 80,
      costGrowth: 1.3,
      color: const Color(0xFFFF003C),
    ),
    CharacterAttribute(
      id: 'stardust_gain',
      name: '星尘收益',
      description: '增加每局获得的星尘数量',
      icon: '✨',
      level: 3,
      maxLevel: 15,
      baseBonus: 0,
      bonusPerLevel: 10,
      upgradeCost: 120,
      costGrowth: 1.4,
      color: const Color(0xFFFFEA00),
    ),
    CharacterAttribute(
      id: 'fire_rate',
      name: '攻击速度',
      description: '提升防御塔的攻击频率',
      icon: '⚡',
      level: 4,
      maxLevel: 15,
      baseBonus: 0,
      bonusPerLevel: 5,
      upgradeCost: 100,
      costGrowth: 1.35,
      color: const Color(0xFF00C3FF),
    ),
    CharacterAttribute(
      id: 'damage',
      name: '伤害加成',
      description: '提升防御塔的基础伤害',
      icon: '⚔️',
      level: 2,
      maxLevel: 15,
      baseBonus: 0,
      bonusPerLevel: 8,
      upgradeCost: 90,
      costGrowth: 1.3,
      color: const Color(0xFFFF6644),
    ),
    CharacterAttribute(
      id: 'slow_resist',
      name: '减速抗性',
      description: '减少被敌人减速效果的影响',
      icon: '🛡️',
      level: 1,
      maxLevel: 10,
      baseBonus: 0,
      bonusPerLevel: 5,
      upgradeCost: 150,
      costGrowth: 1.5,
      color: const Color(0xFF44DDFF),
    ),
    CharacterAttribute(
      id: 'merge_bonus',
      name: '合并经验',
      description: '提升合并时获得的经验值',
      icon: '🔗',
      level: 0,
      maxLevel: 10,
      baseBonus: 0,
      bonusPerLevel: 15,
      upgradeCost: 200,
      costGrowth: 1.6,
      color: const Color(0xFFB700FF),
    ),
  ];

  // 计算当前等级的升级费用
  int _getUpgradeCost(CharacterAttribute attr) {
    return (attr.upgradeCost * pow(attr.costGrowth, attr.level)).round();
  }

  // 计算属性值
  String _getAttributeValue(CharacterAttribute attr) {
    if (attr.id == 'hp') {
      final total = attr.baseHp + attr.hpPerLevel * attr.level;
      return '$total HP';
    } else {
      final total = attr.baseBonus + attr.bonusPerLevel * attr.level;
      return '+${total}%';
    }
  }

  // 计算下一级属性值
  String _getNextAttributeValue(CharacterAttribute attr) {
    if (attr.id == 'hp') {
      final total = attr.baseHp + attr.hpPerLevel * (attr.level + 1);
      return '$total HP';
    } else {
      final total = attr.baseBonus + attr.bonusPerLevel * (attr.level + 1);
      return '+${total}%';
    }
  }

  void _upgradeAttribute(CharacterAttribute attr) {
    final cost = _getUpgradeCost(attr);
    if (_stardust < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('星尘不足！需要 $cost 星尘'),
          backgroundColor: const Color(0xFFFF003C),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (attr.level >= attr.maxLevel) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已达到最高等级！'),
          backgroundColor: const Color(0xFF00F0FF),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _stardust -= cost;
      attr.level++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${attr.name} 升级到 Lv.${attr.level}！'),
        backgroundColor: const Color(0xFF00FF88),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('角色升级'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00F0FF),
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00F0FF)),
      ),
      body: Column(
        children: [
          // 星尘显示
          _buildStardustDisplay(),
          const SizedBox(height: 16),
          // 属性列表
          Expanded(child: _buildAttributeList()),
        ],
      ),
    );
  }

  Widget _buildStardustDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A2240)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFEA00).withOpacity(0.1),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('✨', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '星尘',
                style: TextStyle(fontSize: 13, color: Color(0xFF8899AA)),
              ),
              Text(
                '$_stardust',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFEA00),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _attributes.length,
      itemBuilder: (context, index) {
        return _buildAttributeCard(_attributes[index]);
      },
    );
  }

  Widget _buildAttributeCard(CharacterAttribute attr) {
    final cost = _getUpgradeCost(attr);
    final isMaxLevel = attr.level >= attr.maxLevel;
    final canAfford = _stardust >= cost;
    final progress = attr.level / attr.maxLevel;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: attr.color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: attr.color.withOpacity(0.08), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部信息
          Row(
            children: [
              // 图标
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      attr.color.withOpacity(0.3),
                      attr.color.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(attr.icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              // 名称和描述
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          attr.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // 等级标签
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: attr.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Lv.${attr.level}',
                            style: TextStyle(
                              fontSize: 10,
                              color: attr.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      attr.description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8899AA),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 属性值
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '当前: ${_getAttributeValue(attr)}',
                          style: TextStyle(fontSize: 12, color: attr.color),
                        ),
                        if (!isMaxLevel) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: Color(0xFF667788),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '升级后: ${_getNextAttributeValue(attr)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF00FF88),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    // 等级进度条
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: const Color(0xFF1A2240),
                        valueColor: AlwaysStoppedAnimation<Color>(attr.color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // 升级按钮
              if (isMaxLevel)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF88).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '已满级',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00FF88),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: canAfford ? () => _upgradeAttribute(attr) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: canAfford
                          ? attr.color.withOpacity(0.3)
                          : const Color(0xFF1A2240),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: canAfford ? attr.color : const Color(0xFF334455),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '升级',
                          style: TextStyle(
                            fontSize: 11,
                            color: canAfford
                                ? Colors.white
                                : const Color(0xFF667788),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 8)),
                            const SizedBox(width: 2),
                            Text(
                              '$cost',
                              style: TextStyle(
                                fontSize: 10,
                                color: canAfford
                                    ? const Color(0xFFFFEA00)
                                    : const Color(0xFF667788),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Simple pow implementation to avoid math import
num pow(num base, num exponent) {
  var result = 1.0;
  for (var i = 0; i < exponent.toInt(); i++) {
    result *= base.toDouble();
  }
  return result;
}

class CharacterAttribute {
  final String id;
  final String name;
  final String description;
  final String icon;
  int level;
  final int maxLevel;
  final int baseHp;
  final int hpPerLevel;
  final int baseBonus;
  final int bonusPerLevel;
  final int upgradeCost;
  final double costGrowth;
  final Color color;

  CharacterAttribute({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.level,
    required this.maxLevel,
    this.baseHp = 0,
    this.hpPerLevel = 0,
    this.baseBonus = 0,
    this.bonusPerLevel = 0,
    required this.upgradeCost,
    required this.costGrowth,
    required this.color,
  });
}
