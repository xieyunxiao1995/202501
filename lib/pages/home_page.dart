import 'package:flutter/material.dart';
import '../models/card_stack.dart';
import '../models/diary_entry.dart';
import '../widgets/diary_card.dart';
import '../widgets/dual_glow_background.dart';
import '../constants/app_colors.dart';
import '../services/deepseek_service.dart';
import 'diary_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<CardStack> stacks;
  final Function(List<CardStack>) onStackUpdate;

  const HomePage({
    super.key,
    required this.stacks,
    required this.onStackUpdate,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, bool> _flippedCards = {};
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  bool _showSearch = false;

  Future<void> _handleFlip(String entryId, DiaryEntry entry) async {
    setState(() {
      _flippedCards[entryId] = !(_flippedCards[entryId] ?? false);
    });

    // 如果翻转到背面且没有AI洞察，则请求分析
    if (_flippedCards[entryId]! && entry.aiInsight == null) {
      final result = await DeepSeekService.analyzeDiaryEntry(entry);
      
      // 更新entry
      final updatedStacks = widget.stacks.map((stack) {
        return stack.copyWith(
          cards: stack.cards.map((card) {
            if (card.id == entryId) {
              return card.copyWith(
                aiInsight: result['insight'],
                aiTags: result['tags'],
              );
            }
            return card;
          }).toList(),
        );
      }).toList();
      
      widget.onStackUpdate(updatedStacks);
    }
  }

  void _handleAutoOrganize() {
    final Map<Mood, List<DiaryEntry>> moodGroups = {};
    
    // 收集所有卡片
    for (var stack in widget.stacks) {
      for (var card in stack.cards) {
        moodGroups.putIfAbsent(card.mood, () => []).add(card);
      }
    }

    // 创建新的堆叠
    final newStacks = moodGroups.entries.map((entry) {
      final moodName = {
        Mood.joy: '开心',
        Mood.calm: '平静',
        Mood.anxiety: '焦虑',
        Mood.sadness: '忧郁',
      }[entry.key];

      return CardStack(
        id: 'stack-mood-${entry.key.name}-${DateTime.now().millisecondsSinceEpoch}',
        title: '$moodName时刻',
        cards: entry.value..sort((a, b) => b.date.compareTo(a.date)),
        zIndex: moodGroups.keys.toList().indexOf(entry.key),
        position: Offset(0, 0),
      );
    }).toList();

    widget.onStackUpdate(newStacks);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final screenWidth = MediaQuery.of(context).size.width;

    return DualGlowBackground(
      child: Stack(
        children: [
          // 背景纹理
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: CustomPaint(
                painter: NoisePainter(),
              ),
            ),
          ),

        // 内容
        Column(
          children: [
            // 头部
            Container(
              padding: const EdgeInsets.only(top: 56, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // 日期显示
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${now.year}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink.withValues(alpha: 0.6),
                          letterSpacing: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          width: 1,
                          height: 20,
                          color: AppColors.ink.withValues(alpha: 0.2),
                        ),
                      ),
                      Text(
                        '${now.month}月',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '共 ${widget.stacks.fold<int>(0, (sum, stack) => sum + stack.cards.length)} 张卡片',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.inkLight.withValues(alpha: 0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // 工具栏
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 600 ? 48 : 24,
                vertical: 12,
              ),
              child: Row(
                children: [
                  // 搜索框/按钮
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: _showSearch ? 0.8 : 0.5),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: _showSearch 
                              ? AppColors.ink.withValues(alpha: 0.15)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: _showSearch ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ] : [],
                      ),
                      child: _showSearch
                          ? TextField(
                              autofocus: true,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintText: '搜索你的记忆...',
                                hintStyle: TextStyle(
                                  color: AppColors.ink.withValues(alpha: 0.4),
                                  fontSize: 15,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  color: AppColors.ink,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                  ),
                                  color: AppColors.inkLight,
                                  onPressed: () {
                                    setState(() {
                                      _showSearch = false;
                                      _searchQuery = '';
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  _showSearch = true;
                                });
                              },
                              borderRadius: BorderRadius.circular(22),
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.search_rounded,
                                    color: AppColors.ink.withValues(alpha: 0.5),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '搜索日记',
                                    style: TextStyle(
                                      color: AppColors.ink.withValues(alpha: 0.5),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // 整理按钮
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: widget.stacks.isEmpty
                          ? null
                          : LinearGradient(
                              colors: [
                                AppColors.joy.withValues(alpha: 0.8),
                                AppColors.calm.withValues(alpha: 0.8),
                              ],
                            ),
                      color: widget.stacks.isEmpty
                          ? Colors.white.withValues(alpha: 0.3)
                          : null,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: widget.stacks.isEmpty ? [] : [
                        BoxShadow(
                          color: AppColors.joy.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.stacks.isEmpty ? null : _handleAutoOrganize,
                        borderRadius: BorderRadius.circular(22),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                size: 18,
                                color: widget.stacks.isEmpty
                                    ? AppColors.ink.withValues(alpha: 0.3)
                                    : Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '整理',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: widget.stacks.isEmpty
                                      ? AppColors.ink.withValues(alpha: 0.3)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 卡片区域
            Expanded(
              child: widget.stacks.isEmpty
                  ? _buildEmptyState()
                  : _buildCardList(),
            ),
          ],
        ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 动画图标
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.6),
                        Colors.white.withValues(alpha: 0.3),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    size: 64,
                    color: AppColors.ink.withValues(alpha: 0.4),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            '开始你的记忆之旅',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.ink.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '点击下方 ＋ 按钮创建第一张卡片',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.ink.withValues(alpha: 0.6),
                height: 1.5,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // 提示卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureHint(Icons.mood_rounded, '记录心情'),
              const SizedBox(width: 16),
              _buildFeatureHint(Icons.auto_awesome_rounded, 'AI 洞察'),
              const SizedBox(width: 16),
              _buildFeatureHint(Icons.collections_rounded, '智能整理'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureHint(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.ink.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.ink.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardList() {
    // 筛选卡片
    final filteredStacks = _searchQuery.isEmpty
        ? widget.stacks
        : widget.stacks.where((stack) {
            return stack.cards.any((card) =>
                card.content.toLowerCase().contains(_searchQuery.toLowerCase()));
          }).toList();

    if (filteredStacks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppColors.ink.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '没有找到匹配的内容',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.ink.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '试试其他关键词',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.ink.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 600 ? 320.0 : 300.0;
    final cardHeight = 420.0;

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: 40,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(filteredStacks.length, (index) {
          final stack = filteredStacks[index];
          final topCard = stack.cards.first;
          
          // 类似空档接龙的堆叠效果
          final stackOffset = stack.cards.length > 1 ? 8.0 : 0.0;
          final rotation = (index % 3 - 1) * 0.01;

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 20,
              right: index == filteredStacks.length - 1 ? 0 : 20,
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 80)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Transform.rotate(
                      angle: rotation * value,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 堆叠阴影效果（类似空档接龙）
                          if (stack.cards.length > 1) ...[
                            for (var i = stack.cards.length - 1; i > 0; i--)
                              Positioned(
                                top: i * stackOffset,
                                left: i * (stackOffset / 2),
                                child: Container(
                                  width: cardWidth,
                                  height: cardHeight,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                          // 顶部卡片
                          SizedBox(
                            width: cardWidth,
                            height: cardHeight,
                            child: DiaryCard(
                              entry: topCard,
                              isStacked: stack.cards.length > 1,
                              stackCount: stack.cards.length,
                              isFlipped: _flippedCards[topCard.id] ?? false,
                              onFlipRequest: () => _handleFlip(topCard.id, topCard),
                              onTap: () {
                                if (stack.cards.length > 1) {
                                  _showStackDetail(stack);
                                } else {
                                  _showDiaryDetail(topCard);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _showDiaryDetail(DiaryEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryDetailPage(
          entry: entry,
          isOwn: true,
        ),
      ),
    );
  }

  Widget _buildStackCardItem(DiaryEntry card) {
    Color moodColor;
    switch (card.mood) {
      case Mood.joy:
        moodColor = AppColors.joy;
        break;
      case Mood.calm:
        moodColor = AppColors.calm;
        break;
      case Mood.anxiety:
        moodColor = AppColors.anxiety;
        break;
      case Mood.sadness:
        moodColor = AppColors.sadness;
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showDiaryDetail(card);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: moodColor.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: moodColor.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 情绪色条
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [moodColor, moodColor.withValues(alpha: 0.7)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 日期和心情
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${card.date.month}月${card.date.day}日',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: moodColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getMoodText(card.mood),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: moodColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 图片（如果有）
                  if (card.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        card.image!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  moodColor.withValues(alpha: 0.2),
                                  moodColor.withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.auto_stories_rounded,
                              size: 40,
                              color: moodColor.withValues(alpha: 0.4),
                            ),
                          );
                        },
                      ),
                    ),
                  
                  if (card.image != null) const SizedBox(height: 12),
                  
                  // 内容预览
                  Text(
                    card.content,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: AppColors.ink,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 底部信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (card.location != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.inkLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              card.location!,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.inkLight.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        )
                      else
                        const SizedBox(),
                      
                      Row(
                        children: [
                          Text(
                            '点击查看详情',
                            style: TextStyle(
                              fontSize: 12,
                              color: moodColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: moodColor,
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

  String _getMoodText(Mood mood) {
    switch (mood) {
      case Mood.joy:
        return '开心';
      case Mood.calm:
        return '平静';
      case Mood.anxiety:
        return '焦虑';
      case Mood.sadness:
        return '忧郁';
    }
  }

  void _showStackDetail(CardStack stack) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cardFace,
              AppColors.tableBackground.withValues(alpha: 0.98),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            // 拖动指示器
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.ink.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // 头部
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stack.title ?? '堆叠详情',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${stack.cards.length} 张卡片',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.inkLight.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.ink,
                      iconSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            
            // 卡片列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                physics: const BouncingScrollPhysics(),
                itemCount: stack.cards.length,
                itemBuilder: (context, index) {
                  final card = stack.cards[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 80)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: _buildStackCardItem(card),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.02);
    
    for (var i = 0; i < 1000; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 17) % size.height;
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
