import 'package:flutter/material.dart';
import 'game_screen.dart';

/// 关卡选择页面 - 81关，需通过上一关才能解锁下一关
class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen>
    with SingleTickerProviderStateMixin {
  // 当前已解锁的最高关卡 (1-81)
  int _maxUnlockedLevel = 1;
  // 各关卡的星级评价 (0-3星)
  final Map<int, int> _levelStars = {};

  // 9大章节，每章9关
  final List<ChapterInfo> _chapters = [
    const ChapterInfo(name: '初识星轨', icon: '🌟', color: Color(0xFF00FF88)),
    const ChapterInfo(name: '脉冲觉醒', icon: '⚡', color: Color(0xFF00C3FF)),
    const ChapterInfo(name: '引力漩涡', icon: '🌀', color: Color(0xFFB700FF)),
    const ChapterInfo(name: '相位穿梭', icon: '💫', color: Color(0xFFFF00AA)),
    const ChapterInfo(name: '星环共鸣', icon: '🪐', color: Color(0xFFFFEA00)),
    const ChapterInfo(name: '暗物质潮', icon: '🌑', color: Color(0xFF8844FF)),
    const ChapterInfo(name: '量子纠缠', icon: '🔮', color: Color(0xFFFF6644)),
    const ChapterInfo(name: '时空裂隙', icon: '⏳', color: Color(0xFF44DDFF)),
    const ChapterInfo(name: '终极奥秘', icon: '✨', color: Color(0xFFFFDD44)),
  ];

  int _selectedChapter = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // 模拟加载存档
  void _loadProgress() {
    // 实际项目中应从 SharedPreferences 或数据库读取
    _maxUnlockedLevel = 1;
    _levelStars.clear();
  }

  // 获取章节起始关卡
  int _getChapterStartLevel(int chapterIdx) {
    return chapterIdx * 9 + 1;
  }

  // 获取章节结束关卡
  // ignore: unused_element
  int _getChapterEndLevel(int chapterIdx) {
    return (chapterIdx + 1) * 9;
  }

  // 检查关卡是否已解锁
  bool _isLevelUnlocked(int level) {
    return level <= _maxUnlockedLevel;
  }

  // 检查关卡是否已完成
  bool _isLevelCompleted(int level) {
    return _levelStars.containsKey(level) && _levelStars[level]! > 0;
  }

  // 进入关卡
  Future<void> _enterLevel(int level) async {
    if (!_isLevelUnlocked(level)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('请先通过第 ${level - 1} 关解锁此关卡'),
          backgroundColor: const Color(0xFFFF003C),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 跳转到游戏界面
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => GameScreen(level: level, showTitle: false),
      ),
    );

    // 如果通关成功，解锁下一关
    if (result == true && level < 81) {
      if (level >= _maxUnlockedLevel) {
        setState(() {
          _maxUnlockedLevel = level + 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 第 ${level + 1} 关已解锁！'),
            backgroundColor: const Color(0xFF00FF88),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
        title: const Text('选择关卡'),
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
          // 章节选择栏
          _buildChapterSelector(),
          const SizedBox(height: 16),
          // 进度信息
          _buildProgressInfo(),
          const SizedBox(height: 16),
          // 关卡网格
          Expanded(child: _buildLevelGrid()),
        ],
      ),
    );
  }

  Widget _buildChapterSelector() {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _chapters.length,
        itemBuilder: (context, index) {
          final chapter = _chapters[index];
          final isSelected = _selectedChapter == index;
          final startLevel = _getChapterStartLevel(index);
          final hasUnlocked = startLevel <= _maxUnlockedLevel;

          return GestureDetector(
            onTap: () {
              if (hasUnlocked) {
                setState(() => _selectedChapter = index);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('需要完成第 ${startLevel - 1} 关解锁此章节'),
                    backgroundColor: const Color(0xFFFF003C),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? chapter.color.withOpacity(0.3)
                    : hasUnlocked
                    ? const Color(0xFF0A1628)
                    : const Color(0xFF060A12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? chapter.color
                      : hasUnlocked
                      ? chapter.color.withOpacity(0.4)
                      : const Color(0xFF1A2240),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: chapter.color.withOpacity(0.3),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(chapter.icon, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 2),
                  Text(
                    chapter.name,
                    style: TextStyle(
                      fontSize: 11,
                      color: hasUnlocked
                          ? isSelected
                                ? Colors.white
                                : chapter.color.withOpacity(0.8)
                          : const Color(0xFF445566),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            '探索进度',
            style: TextStyle(color: Color(0xFF8899AA), fontSize: 13),
          ),
          const Spacer(),
          Text(
            '$_maxUnlockedLevel / 81',
            style: const TextStyle(
              color: Color(0xFF00F0FF),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelGrid() {
    final startLevel = _getChapterStartLevel(_selectedChapter);
    final chapterColor = _chapters[_selectedChapter].color;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final level = startLevel + index;
        return _buildLevelCard(level, chapterColor);
      },
    );
  }

  Widget _buildLevelCard(int level, Color chapterColor) {
    final unlocked = _isLevelUnlocked(level);
    final completed = _isLevelCompleted(level);
    final stars = _levelStars[level] ?? 0;

    return GestureDetector(
      onTap: () => _enterLevel(level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: unlocked ? const Color(0xFF0A1628) : const Color(0xFF060A12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unlocked
                ? chapterColor.withOpacity(completed ? 0.6 : 0.3)
                : const Color(0xFF1A2240),
            width: unlocked ? 2 : 1,
          ),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: chapterColor.withOpacity(completed ? 0.2 : 0.1),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 关卡编号
            Stack(
              alignment: Alignment.center,
              children: [
                // 解锁状态图标
                if (!unlocked)
                  const Icon(Icons.lock, size: 32, color: Color(0xFF334455))
                else
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          chapterColor.withOpacity(0.3),
                          chapterColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$level',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: chapterColor,
                        ),
                      ),
                    ),
                  ),
                // 完成标记
                if (completed)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: chapterColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 10,
                        color: Color(0xFF030408),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // 星级评价
            if (unlocked)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Icon(
                    i < stars ? Icons.star : Icons.star_border,
                    size: 14,
                    color: i < stars
                        ? const Color(0xFFFFEA00)
                        : const Color(0xFF334455),
                  );
                }),
              )
            else
              const Text(
                '未解锁',
                style: TextStyle(fontSize: 10, color: Color(0xFF445566)),
              ),
          ],
        ),
      ),
    );
  }
}

class ChapterInfo {
  final String name;
  final String icon;
  final Color color;

  const ChapterInfo({
    required this.name,
    required this.icon,
    required this.color,
  });
}
