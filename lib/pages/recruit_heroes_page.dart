import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/general/general_model.dart';

/// 招募武将页面
///
/// 从底部导航"招募"入口进入，选择至多 4 名武将后开始战斗。
/// 上半部分展示已选武将槽位与开始战斗按钮，
/// 下半部分为可招募武将网格。
class RecruitHeroesPage extends StatefulWidget {
  const RecruitHeroesPage({super.key});

  @override
  State<RecruitHeroesPage> createState() => _RecruitHeroesPageState();
}

class _RecruitHeroesPageState extends State<RecruitHeroesPage> {
  static const _backgroundImage = 'assets/images/ui/story_bg.png';
  static const _maxSlots = 4;

  /// 可选武将池
  static const _availableHeroes = <GeneralModel>[
    GeneralModel(id: 'zhaoyun', name: '赵云', kingdom: 'shu', profession: 'guardian', rarity: 'ssr', star: 5, level: 50, atk: 880, def: 650, hp: 9800, spd: 92, power: 27200),
    GeneralModel(id: 'zhangfei', name: '张飞', kingdom: 'shu', profession: 'berserker', rarity: 'ssr', star: 5, level: 48, atk: 960, def: 480, hp: 9200, spd: 68, power: 25800),
    GeneralModel(id: 'huangzhong', name: '黄忠', kingdom: 'shu', profession: 'assassin', rarity: 'sr', star: 4, level: 45, atk: 780, def: 350, hp: 6500, spd: 75, power: 18800),
    GeneralModel(id: 'machao', name: '马超', kingdom: 'shu', profession: 'assassin', rarity: 'ssr', star: 5, level: 47, atk: 920, def: 420, hp: 8200, spd: 95, power: 26200),
    GeneralModel(id: 'xuchu', name: '许褚', kingdom: 'wei', profession: 'guardian', rarity: 'sr', star: 4, level: 44, atk: 720, def: 680, hp: 10500, spd: 55, power: 19600),
    GeneralModel(id: 'xiahoudun', name: '夏侯惇', kingdom: 'wei', profession: 'berserker', rarity: 'sr', star: 4, level: 46, atk: 820, def: 520, hp: 7800, spd: 70, power: 20800),
    GeneralModel(id: 'dianwei', name: '典韦', kingdom: 'wei', profession: 'guardian', rarity: 'ssr', star: 5, level: 48, atk: 890, def: 700, hp: 11000, spd: 62, power: 27500),
    GeneralModel(id: 'zhanghe', name: '张郃', kingdom: 'wei', profession: 'warSage', rarity: 'sr', star: 4, level: 43, atk: 760, def: 450, hp: 7200, spd: 78, power: 18200),
    GeneralModel(id: 'ganning', name: '甘宁', kingdom: 'wu', profession: 'assassin', rarity: 'sr', star: 4, level: 44, atk: 800, def: 380, hp: 6800, spd: 88, power: 19200),
    GeneralModel(id: 'zhouyu', name: '周瑜', kingdom: 'wu', profession: 'strategist', rarity: 'ssr', star: 5, level: 50, atk: 720, def: 420, hp: 7600, spd: 72, power: 24200),
    GeneralModel(id: 'taishici', name: '太史慈', kingdom: 'wu', profession: 'assassin', rarity: 'sr', star: 4, level: 45, atk: 840, def: 400, hp: 7000, spd: 82, power: 19800),
    GeneralModel(id: 'luxun', name: '陆逊', kingdom: 'wu', profession: 'strategist', rarity: 'sr', star: 4, level: 42, atk: 680, def: 380, hp: 6400, spd: 65, power: 16800),
    GeneralModel(id: 'lvmeng', name: '吕蒙', kingdom: 'wu', profession: 'warSage', rarity: 'sr', star: 4, level: 43, atk: 740, def: 460, hp: 7000, spd: 72, power: 17800),
    GeneralModel(id: 'huangyueying', name: '黄月英', kingdom: 'shu', profession: 'support', rarity: 'sr', star: 4, level: 41, atk: 520, def: 360, hp: 5800, spd: 58, power: 14800),
    GeneralModel(id: 'zhenji', name: '甄姬', kingdom: 'wei', profession: 'support', rarity: 'sr', star: 4, level: 40, atk: 480, def: 340, hp: 5600, spd: 60, power: 14200),
  ];

  final List<GeneralModel> _selected = [];

  bool _isSelected(GeneralModel hero) => _selected.any((h) => h.id == hero.id);

  void _toggleHero(GeneralModel hero) {
    setState(() {
      if (_isSelected(hero)) {
        _selected.removeWhere((h) => h.id == hero.id);
      } else if (_selected.length < _maxSlots) {
        _selected.add(hero);
      }
    });
  }

  void _startBattle() {
    if (_selected.length < _maxSlots) return;
    context.pushNamed('battle', extra: List<GeneralModel>.from(_selected));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景图
          Image.asset(_backgroundImage, fit: BoxFit.cover),
          // 遮罩
          ColoredBox(color: const Color(0xCC1A0F0A)),
          SafeArea(
            child: Column(
              children: [
                // ====== 上半部分：已选英雄面板 ======
                _buildSelectedPanel(),
                const SizedBox(height: 8),
                // ====== 下半部分：英雄列表 ======
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    decoration: BoxDecoration(
                      color: const Color(0xCC1A1A2A),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      border: Border(top: BorderSide(color: const Color(0x30A11717), width: 1)),
                    ),
                    child: _buildHeroGrid(),
                  ),
                ),
              ],
            ),
          ),
          // 返回按钮
          // Positioned(
          //   left: 16,
          //   top: 48,
          //   child: GestureDetector(
          //     onTap: () => context.pop(),
          //     child: Container(
          //       width: 36,
          //       height: 36,
          //       decoration: BoxDecoration(
          //         color: const Color(0x20FFFFFF),
          //         borderRadius: BorderRadius.circular(18),
          //       ),
          //       child: const Icon(Icons.arrow_back, color: Color(0xFFE2D9CD), size: 20),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // ==================== 已选英雄面板 ====================

  Widget _buildSelectedPanel() {
    final isFull = _selected.length >= _maxSlots;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 56, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xCC1A1A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x30A11717)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '选择武将',
                style: TextStyle(
                  color: Color(0xFFE2D9CD),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_selected.length} / $_maxSlots',
                style: TextStyle(
                  color: isFull ? const Color(0xFFD4A84B) : const Color(0x668B7E6A),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 英雄槽位
          Row(
            children: List.generate(_maxSlots, (i) {
              if (i < _selected.length) {
                return Expanded(
                  child: _SelectedHeroChip(
                    hero: _selected[i],
                    onRemove: () => _toggleHero(_selected[i]),
                  ),
                );
              }
              return const Expanded(child: _EmptySlot());
            }),
          ),
          const SizedBox(height: 12),
          // 开始战斗按钮
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isFull ? const Color(0xFFA11717) : const Color(0x406A0F0F),
                foregroundColor: isFull ? const Color(0xFFE2D9CD) : const Color(0x556A0F0F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: isFull ? _startBattle : null,
              child: const Text(
                '开始战斗',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 英雄网格 ====================

  Widget _buildHeroGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: _availableHeroes.length,
      itemBuilder: (context, index) {
        final hero = _availableHeroes[index];
        final isSelected = _isSelected(hero);
        final isFull = _selected.length >= _maxSlots && !isSelected;

        return GestureDetector(
          onTap: isFull ? null : () => _toggleHero(hero),
          child: _HeroCard(hero: hero, isSelected: isSelected, disabled: isFull),
        );
      },
    );
  }
}

// =================================================================
// 已选英雄槽位（带移除按钮）
// =================================================================

class _SelectedHeroChip extends StatelessWidget {
  const _SelectedHeroChip({required this.hero, required this.onRemove});

  final GeneralModel hero;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0x80A11717),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xCCD4A84B), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    hero.name.substring(0, 1),
                    style: const TextStyle(
                      color: Color(0xFFE2D9CD),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hero.name,
                style: const TextStyle(color: Color(0x99E2D9CD), fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Positioned(
            right: -2,
            top: -4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFFA11717),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Color(0xFFE2D9CD), size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// 空槽位
// =================================================================

class _EmptySlot extends StatelessWidget {
  const _EmptySlot();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x206A0F0F)),
            ),
            child: const Center(
              child: Icon(Icons.add, color: Color(0x206A0F0F), size: 24),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '待选',
            style: TextStyle(color: const Color(0x556A0F0F).withAlpha(60), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// 英雄卡片（网格中）
// =================================================================

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.hero,
    required this.isSelected,
    required this.disabled,
  });

  final GeneralModel hero;
  final bool isSelected;
  final bool disabled;

  /// 稀有度颜色
  static const _rarityColors = {
    'n': Color(0xFF888888),
    'r': Color(0xFF4A90D9),
    'sr': Color(0xFF9B59B6),
    'ssr': Color(0xFFD4A84B),
    'ur': Color(0xFFE74C3C),
    'legendary': Color(0xFFFF6B35),
  };

  Color get _rarityColor => _rarityColors[hero.rarity] ?? const Color(0xFF888888);

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? const Color(0xFFD4A84B)
        : disabled
            ? const Color(0x106A0F0F)
            : const Color(0x206A0F0F);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0x40A11717)
            : const Color(0x08FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 头像方块
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0x60A11717)
                  : const Color(0x10FFFFFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _rarityColor.withAlpha(80), width: 1),
            ),
            child: Center(
              child: Text(
                hero.name.substring(0, 1),
                style: TextStyle(
                  color: isSelected ? const Color(0xFFE2D9CD) : _rarityColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // 名称
          Text(
            hero.name,
            style: TextStyle(
              color: isSelected ? const Color(0xFFE2D9CD) : const Color(0x99E2D9CD),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // 稀有度标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: _rarityColor.withAlpha(30),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              hero.rarity.toUpperCase(),
              style: TextStyle(fontSize: 8, color: _rarityColor, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 2),
          // 战力
          Text(
            '⚔ ${hero.power}',
            style: TextStyle(color: const Color(0xFFE2D9CD).withAlpha(80), fontSize: 10),
          ),
          // 选中图标
          if (isSelected)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.check_circle, color: Color(0xFFD4A84B), size: 10),
            ),
          if (disabled)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.block, color: Color(0x206A0F0F), size: 16),
            ),
        ],
      ),
    );
  }
}
