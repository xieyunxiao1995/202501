import 'package:flutter/material.dart';

/// 卡片升级页面
class CardUpgradeScreen extends StatefulWidget {
  const CardUpgradeScreen({super.key});

  @override
  State<CardUpgradeScreen> createState() => _CardUpgradeScreenState();
}

class _CardUpgradeScreenState extends State<CardUpgradeScreen>
    with SingleTickerProviderStateMixin {
  int _stardust = 2800;
  int _cardFragments = 150; // 卡片碎片数量

  String _selectedTab = '已拥有';
  final List<String> _tabs = ['已拥有', '碎片合成', '卡牌图鉴'];

  final List<CardItem> _ownedCards = [
    CardItem(
      id: 'card_1',
      name: '基础脉冲',
      description: '提升基础节点10%攻击力',
      icon: '🔵',
      tier: 'R',
      tierColor: const Color(0xFF00FF88),
      level: 8,
      maxLevel: 10,
      effect: '+10% 攻击力',
      nextEffect: '+12% 攻击力',
      upgradeCost: 50,
      fragmentCost: 0,
      color: const Color(0xFF00FF88),
    ),
    CardItem(
      id: 'card_2',
      name: '引力波',
      description: '引力塔攻击范围+15%',
      icon: '🟣',
      tier: 'SR',
      tierColor: const Color(0xFFB700FF),
      level: 5,
      maxLevel: 10,
      effect: '+15% 范围',
      nextEffect: '+18% 范围',
      upgradeCost: 120,
      fragmentCost: 20,
      color: const Color(0xFFB700FF),
    ),
    CardItem(
      id: 'card_3',
      name: '相位突袭',
      description: '相位塔有10%概率二次攻击',
      icon: '🔴',
      tier: 'SR',
      tierColor: const Color(0xFFFF00AA),
      level: 3,
      maxLevel: 10,
      effect: '10% 触发',
      nextEffect: '13% 触发',
      upgradeCost: 150,
      fragmentCost: 25,
      color: const Color(0xFFFF00AA),
    ),
    CardItem(
      id: 'card_4',
      name: '星环共鸣',
      description: '星环塔攻击附带溅射伤害',
      icon: '🟡',
      tier: 'SSR',
      tierColor: const Color(0xFFFFEA00),
      level: 1,
      maxLevel: 10,
      effect: '20% 溅射',
      nextEffect: '25% 溅射',
      upgradeCost: 300,
      fragmentCost: 50,
      color: const Color(0xFFFFEA00),
    ),
    CardItem(
      id: 'card_5',
      name: '量子护盾',
      description: '基地每10秒获得一个护盾',
      icon: '🛡️',
      tier: 'SSR',
      tierColor: const Color(0xFF44DDFF),
      level: 0,
      maxLevel: 10,
      effect: '未激活',
      nextEffect: '护盾50点',
      upgradeCost: 500,
      fragmentCost: 80,
      color: const Color(0xFF44DDFF),
    ),
    CardItem(
      id: 'card_6',
      name: '暗物质爆发',
      description: '击杀敌人时有概率获得双倍星尘',
      icon: '🌑',
      tier: 'SSR',
      tierColor: const Color(0xFF8844FF),
      level: 2,
      maxLevel: 10,
      effect: '5% 触发',
      nextEffect: '8% 触发',
      upgradeCost: 400,
      fragmentCost: 60,
      color: const Color(0xFF8844FF),
    ),
  ];

  final List<CardFragmentRecipe> _recipes = [
    CardFragmentRecipe(
      cardName: '脉冲强化',
      icon: '⚡',
      tier: 'R',
      tierColor: const Color(0xFF00FF88),
      requiredFragments: 30,
      color: const Color(0xFF00FF88),
    ),
    CardFragmentRecipe(
      cardName: '引力透镜',
      icon: '🌀',
      tier: 'SR',
      tierColor: const Color(0xFFB700FF),
      requiredFragments: 50,
      color: const Color(0xFFB700FF),
    ),
    CardFragmentRecipe(
      cardName: '时空扭曲',
      icon: '⏳',
      tier: 'SSR',
      tierColor: const Color(0xFFFFEA00),
      requiredFragments: 100,
      color: const Color(0xFFFFEA00),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('卡片升级'),
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
          // 资源显示
          _buildResourceDisplay(),
          const SizedBox(height: 12),
          // 标签切换
          _buildTabBar(),
          const SizedBox(height: 12),
          // 内容区域
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildResourceDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A2240)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _resourceItem('✨', '星尘', '$_stardust', const Color(0xFFFFEA00)),
          Container(width: 1, height: 36, color: const Color(0xFF1A2240)),
          _resourceItem('🃏', '碎片', '$_cardFragments', const Color(0xFF00C3FF)),
        ],
      ),
    );
  }

  Widget _resourceItem(String icon, String label, String value, Color color) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF8899AA)),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final tab = _tabs[index];
          final isSelected = _selectedTab == tab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00F0FF).withOpacity(0.2)
                    : const Color(0xFF0A1628),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00F0FF)
                      : const Color(0xFF1A2240),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? const Color(0xFF00F0FF)
                        : const Color(0xFF8899AA),
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case '已拥有':
        return _buildOwnedCards();
      case '碎片合成':
        return _buildFragmentSynthesis();
      case '卡牌图鉴':
        return _buildCardCatalog();
      default:
        return _buildOwnedCards();
    }
  }

  Widget _buildOwnedCards() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _ownedCards.length,
      itemBuilder: (context, index) {
        return _buildCardItem(_ownedCards[index]);
      },
    );
  }

  Widget _buildCardItem(CardItem card) {
    final isMaxLevel = card.level >= card.maxLevel;
    final canAffordStardust = _stardust >= card.upgradeCost;
    final canAffordFragments = _cardFragments >= card.fragmentCost;
    final canUpgrade = canAffordStardust && canAffordFragments && !isMaxLevel;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: card.color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: card.color.withOpacity(0.08), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 卡片头部
          Row(
            children: [
              // 卡片图标
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      card.color.withOpacity(0.4),
                      card.color.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(color: card.color.withOpacity(0.5)),
                ),
                child: Center(
                  child: Text(card.icon, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 12),
              // 卡片信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          card.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // 稀有度标签
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: card.tierColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: card.tierColor),
                          ),
                          child: Text(
                            card.tier,
                            style: TextStyle(
                              fontSize: 9,
                              color: card.tierColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.description,
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
          // 等级和效果
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Lv.${card.level} / ${card.maxLevel}',
                          style: TextStyle(
                            fontSize: 12,
                            color: card.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '效果: ${card.effect}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFAABBCC),
                          ),
                        ),
                      ],
                    ),
                    if (!isMaxLevel) ...[
                      const SizedBox(height: 4),
                      Text(
                        '升级后: ${card.nextEffect}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF00FF88),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    // 经验条
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: card.level / card.maxLevel,
                        minHeight: 4,
                        backgroundColor: const Color(0xFF1A2240),
                        valueColor: AlwaysStoppedAnimation<Color>(card.color),
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
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF88).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '已满级',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF00FF88),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: canUpgrade ? () => _upgradeCard(card) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: canUpgrade
                          ? card.color.withOpacity(0.3)
                          : const Color(0xFF1A2240),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: canUpgrade
                            ? card.color
                            : const Color(0xFF334455),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '升级',
                          style: TextStyle(
                            fontSize: 11,
                            color: canUpgrade
                                ? Colors.white
                                : const Color(0xFF667788),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 8)),
                            Text(
                              ' ${card.upgradeCost}',
                              style: TextStyle(
                                fontSize: 9,
                                color: canUpgrade
                                    ? const Color(0xFFFFEA00)
                                    : const Color(0xFF667788),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text('🃏', style: TextStyle(fontSize: 8)),
                            Text(
                              ' ${card.fragmentCost}',
                              style: TextStyle(
                                fontSize: 9,
                                color: canUpgrade
                                    ? const Color(0xFF00C3FF)
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

  Widget _buildFragmentSynthesis() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        final canSynthesize = _cardFragments >= recipe.requiredFragments;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1628),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: recipe.color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(color: recipe.color.withOpacity(0.08), blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      recipe.color.withOpacity(0.3),
                      recipe.color.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    recipe.icon,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          recipe.cardName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: recipe.tierColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            recipe.tier,
                            style: TextStyle(
                              fontSize: 9,
                              color: recipe.tierColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text('🃏', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          '${_cardFragments} / ${recipe.requiredFragments}',
                          style: TextStyle(
                            fontSize: 13,
                            color: canSynthesize
                                ? const Color(0xFF00C3FF)
                                : const Color(0xFF8899AA),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: canSynthesize
                    ? () {
                        setState(() {
                          _cardFragments -= recipe.requiredFragments;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('成功合成 ${recipe.cardName}！'),
                            backgroundColor: recipe.color,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: canSynthesize
                        ? recipe.color.withOpacity(0.3)
                        : const Color(0xFF1A2240),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: canSynthesize
                          ? recipe.color
                          : const Color(0xFF334455),
                    ),
                  ),
                  child: Text(
                    '合成',
                    style: TextStyle(
                      fontSize: 12,
                      color: canSynthesize
                          ? Colors.white
                          : const Color(0xFF667788),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardCatalog() {
    // 图鉴显示所有卡片（包括未拥有的）
    final allCards = [
      ..._ownedCards,
      CardItem(
        id: 'card_7',
        name: '时空冻结',
        description: '攻击有概率冻结敌人',
        icon: '❄️',
        tier: 'SSR',
        tierColor: const Color(0xFF44DDFF),
        level: 0,
        maxLevel: 10,
        effect: '未解锁',
        nextEffect: '3% 冻结',
        upgradeCost: 600,
        fragmentCost: 100,
        color: const Color(0xFF44DDFF),
        isOwned: false,
      ),
      CardItem(
        id: 'card_8',
        name: '宇宙射线',
        description: '全塔攻击+20%',
        icon: '☀️',
        tier: 'SSR',
        tierColor: const Color(0xFFFFDD44),
        level: 0,
        maxLevel: 10,
        effect: '未解锁',
        nextEffect: '+20% 攻击',
        upgradeCost: 800,
        fragmentCost: 120,
        color: const Color(0xFFFFDD44),
        isOwned: false,
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: allCards.length,
      itemBuilder: (context, index) {
        final card = allCards[index];
        return _buildCatalogCard(card);
      },
    );
  }

  Widget _buildCatalogCard(CardItem card) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: card.isOwned ? const Color(0xFF0A1628) : const Color(0xFF060A12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: card.isOwned
              ? card.color.withOpacity(0.4)
              : const Color(0xFF1A2240),
        ),
        boxShadow: card.isOwned
            ? [BoxShadow(color: card.color.withOpacity(0.1), blurRadius: 8)]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(card.icon, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(
            card.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: card.isOwned ? Colors.white : const Color(0xFF667788),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: card.tierColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              card.tier,
              style: TextStyle(
                fontSize: 9,
                color: card.tierColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (!card.isOwned)
            const Text(
              '未解锁',
              style: TextStyle(fontSize: 10, color: Color(0xFF445566)),
            )
          else
            Text(
              'Lv.${card.level}',
              style: TextStyle(
                fontSize: 10,
                color: card.color,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  void _upgradeCard(CardItem card) {
    if (_stardust >= card.upgradeCost &&
        _cardFragments >= card.fragmentCost &&
        card.level < card.maxLevel) {
      setState(() {
        _stardust -= card.upgradeCost;
        _cardFragments -= card.fragmentCost;
        card.level++;
        card.effect = card.nextEffect;
        // 计算下一级效果
        final bonusPercent = 10 + (card.level * 3);
        card.nextEffect = '+${bonusPercent}% 攻击力';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${card.name} 升级到 Lv.${card.level}！'),
          backgroundColor: const Color(0xFF00FF88),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class CardItem {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String tier;
  final Color tierColor;
  int level;
  final int maxLevel;
  String effect;
  String nextEffect;
  final int upgradeCost;
  final int fragmentCost;
  final Color color;
  final bool isOwned;

  CardItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.tier,
    required this.tierColor,
    required this.level,
    required this.maxLevel,
    required this.effect,
    required this.nextEffect,
    required this.upgradeCost,
    required this.fragmentCost,
    required this.color,
    this.isOwned = true,
  });
}

class CardFragmentRecipe {
  final String cardName;
  final String icon;
  final String tier;
  final Color tierColor;
  final int requiredFragments;
  final Color color;

  const CardFragmentRecipe({
    required this.cardName,
    required this.icon,
    required this.tier,
    required this.tierColor,
    required this.requiredFragments,
    required this.color,
  });
}
