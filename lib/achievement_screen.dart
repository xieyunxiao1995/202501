import 'package:flutter/material.dart';

/// 成就页面
class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen>
    with SingleTickerProviderStateMixin {
  // 模拟成就数据
  final List<Achievement> _achievements = [
    // 新手系列
    Achievement(
      id: 'newbie_1',
      title: '初次启航',
      description: '完成第一关',
      icon: '🚀',
      category: '新手',
      isCompleted: true,
      color: const Color(0xFF00FF88),
    ),
    Achievement(
      id: 'newbie_2',
      title: '渐入佳境',
      description: '通过第10关',
      icon: '🌟',
      category: '新手',
      isCompleted: false,
      color: const Color(0xFF00FF88),
    ),
    Achievement(
      id: 'newbie_3',
      title: '星轨学徒',
      description: '通过第27关',
      icon: '📚',
      category: '新手',
      isCompleted: false,
      color: const Color(0xFF00FF88),
    ),
    // 合并大师系列
    Achievement(
      id: 'merge_1',
      title: '合成新手',
      description: '完成50次合并',
      icon: '🔗',
      category: '合并大师',
      isCompleted: true,
      color: const Color(0xFF00C3FF),
    ),
    Achievement(
      id: 'merge_2',
      title: '合并达人',
      description: '完成500次合并',
      icon: '⚙️',
      category: '合并大师',
      isCompleted: false,
      color: const Color(0xFF00C3FF),
    ),
    Achievement(
      id: 'merge_3',
      title: '合并之神',
      description: '完成2000次合并',
      icon: '👑',
      category: '合并大师',
      isCompleted: false,
      color: const Color(0xFF00C3FF),
    ),
    // 战斗系列
    Achievement(
      id: 'battle_1',
      title: '初战告捷',
      description: '消灭100个敌人',
      icon: '⚔️',
      category: '战斗',
      isCompleted: true,
      color: const Color(0xFFFF003C),
    ),
    Achievement(
      id: 'battle_2',
      title: '战神降临',
      description: '消灭1000个敌人',
      icon: '🛡️',
      category: '战斗',
      isCompleted: false,
      color: const Color(0xFFFF003C),
    ),
    Achievement(
      id: 'battle_3',
      title: '星辰守护者',
      description: '在不损失基地HP的情况下通关',
      icon: '💎',
      category: '战斗',
      isCompleted: false,
      color: const Color(0xFFFF003C),
    ),
    // 连击系列
    Achievement(
      id: 'combo_1',
      title: '连击入门',
      description: '达到5连击',
      icon: '🔥',
      category: '连击',
      isCompleted: true,
      color: const Color(0xFFFFEA00),
    ),
    Achievement(
      id: 'combo_2',
      title: '连击高手',
      description: '达到20连击',
      icon: '💥',
      category: '连击',
      isCompleted: false,
      color: const Color(0xFFFFEA00),
    ),
    Achievement(
      id: 'combo_3',
      title: '连击传说',
      description: '达到50连击',
      icon: '🌈',
      category: '连击',
      isCompleted: false,
      color: const Color(0xFFFFEA00),
    ),
    // 探索系列
    Achievement(
      id: 'explore_1',
      title: '星际探索者',
      description: '解锁所有章节',
      icon: '🗺️',
      category: '探索',
      isCompleted: false,
      color: const Color(0xFFB700FF),
    ),
    Achievement(
      id: 'explore_2',
      title: '星轨大师',
      description: '通过全部81关',
      icon: '✨',
      category: '探索',
      isCompleted: false,
      color: const Color(0xFFB700FF),
    ),
    Achievement(
      id: 'explore_3',
      title: '三星收藏家',
      description: '所有关卡获得3星评价',
      icon: '⭐',
      category: '探索',
      isCompleted: false,
      color: const Color(0xFFB700FF),
    ),
  ];

  String _selectedCategory = '全部';
  late final List<String> _categories;

  @override
  void initState() {
    super.initState();
    _categories = ['全部', ..._achievements.map((a) => a.category).toSet()];
  }

  List<Achievement> get _filteredAchievements {
    if (_selectedCategory == '全部') return _achievements;
    return _achievements.where((a) => a.category == _selectedCategory).toList();
  }

  int get _completedCount => _achievements.where((a) => a.isCompleted).length;

  double get _completionRate => _completedCount / _achievements.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('成就殿堂'),
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
          // 总进度
          _buildTotalProgress(),
          const SizedBox(height: 16),
          // 分类标签
          _buildCategoryTabs(),
          const SizedBox(height: 12),
          // 成就列表
          Expanded(child: _buildAchievementList()),
        ],
      ),
    );
  }

  Widget _buildTotalProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A2240)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F0FF).withOpacity(0.1),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '🏆 总成就',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '$_completedCount / ${_achievements.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00F0FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _completionRate,
              minHeight: 8,
              backgroundColor: const Color(0xFF1A2240),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF00F0FF),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(_completionRate * 100).toStringAsFixed(1)}% 已完成',
            style: const TextStyle(fontSize: 12, color: Color(0xFF8899AA)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
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
                  category,
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

  Widget _buildAchievementList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredAchievements.length,
      itemBuilder: (context, index) {
        return _buildAchievementCard(_filteredAchievements[index]);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: achievement.isCompleted
            ? const Color(0xFF0A1628)
            : const Color(0xFF060A12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: achievement.isCompleted
              ? achievement.color.withOpacity(0.4)
              : const Color(0xFF1A2240),
          width: 1.5,
        ),
        boxShadow: achievement.isCompleted
            ? [
                BoxShadow(
                  color: achievement.color.withOpacity(0.15),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // 图标
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  achievement.isCompleted
                      ? achievement.color.withOpacity(0.3)
                      : const Color(0xFF223344).withOpacity(0.3),
                  achievement.isCompleted
                      ? achievement.color.withOpacity(0.05)
                      : const Color(0xFF223344).withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // 信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      achievement.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: achievement.isCompleted
                            ? Colors.white
                            : const Color(0xFF667788),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (achievement.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: achievement.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '已完成',
                          style: TextStyle(
                            fontSize: 10,
                            color: achievement.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8899AA),
                  ),
                ),
              ],
            ),
          ),
          // 状态图标
          Icon(
            achievement.isCompleted ? Icons.check_circle : Icons.lock_outline,
            color: achievement.isCompleted
                ? achievement.color
                : const Color(0xFF334455),
            size: 24,
          ),
        ],
      ),
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final bool isCompleted;
  final Color color;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.isCompleted,
    required this.color,
  });
}
