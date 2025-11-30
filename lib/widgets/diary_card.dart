import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/diary_entry.dart';
import '../constants/app_colors.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final bool isStacked;
  final int stackCount;
  final bool isFlipped;
  final VoidCallback? onFlipRequest;
  final VoidCallback? onTap;

  const DiaryCard({
    super.key,
    required this.entry,
    this.isStacked = false,
    this.stackCount = 1,
    this.isFlipped = false,
    this.onFlipRequest,
    this.onTap,
  });

  Color get moodColor {
    switch (entry.mood) {
      case Mood.joy:
        return AppColors.joy;
      case Mood.calm:
        return AppColors.calm;
      case Mood.anxiety:
        return AppColors.anxiety;
      case Mood.sadness:
        return AppColors.sadness;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // 堆叠效果的底层卡片
          if (isStacked && stackCount > 1) ..._buildStackLayers(),
          
          // 主卡片
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (child, animation) {
              final rotate = Tween(begin: 0.0, end: 1.0).animate(animation);
              return AnimatedBuilder(
                animation: rotate,
                child: child,
                builder: (context, child) {
                  final angle = rotate.value * 3.14159;
                  final isUnder = angle > 3.14159 / 2;
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    alignment: Alignment.center,
                    child: isUnder
                        ? Transform(
                            transform: Matrix4.identity()..rotateY(3.14159),
                            alignment: Alignment.center,
                            child: child,
                          )
                        : child,
                  );
                },
              );
            },
            child: isFlipped
                ? _buildBackFace()
                : _buildFrontFace(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStackLayers() {
    return List.generate(
      (stackCount - 1).clamp(0, 2),
      (index) {
        final offset = (index + 1) * 4.0;
        return Positioned(
          top: offset,
          left: 0,
          right: 0,
          bottom: -offset,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEE9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.ink.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFrontFace() {
    return Container(
      key: const ValueKey('front'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardFace,
            AppColors.cardFace.withValues(alpha: 0.98),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: moodColor.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部情绪色条
          Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  moodColor,
                  moodColor.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 日期头部
                  _buildDateHeader(),
                  const SizedBox(height: 16),
                  
                  // 内容区域
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 始终显示图片，如果没有则显示默认图片
                          _buildImageAttachment(),
                          const SizedBox(height: 16),
                          Text(
                            entry.content,
                            style: const TextStyle(
                              fontSize: 15.5,
                              height: 1.7,
                              color: AppColors.ink,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // 底部操作栏
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackFace() {
    return Container(
      key: const ValueKey('back'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBack,
            AppColors.cardBack.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 几何图案背景
          Positioned.fill(child: _buildPattern()),
          
          // 内容
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 32,
                    color: moodColor,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'AI 洞察',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    entry.aiInsight ?? '正在分析你的心情...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: AppColors.ink.withValues(alpha: 0.85),
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                if (entry.aiTags != null && entry.aiTags!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: entry.aiTags!.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const Spacer(),
                TextButton(
                  onPressed: onFlipRequest,
                  child: Text(
                    '翻回正面',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink.withValues(alpha: 0.5),
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    final day = entry.date.day;
    final month = entry.date.month;
    final year = entry.date.year;
    final weekday = DateFormat('EEEE', 'zh_CN').format(entry.date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$day',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '日',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
            Text(
              '$year年$month月',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.inkLight,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              weekday,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.inkLight.withValues(alpha: 0.6),
              ),
            ),
            if (entry.location != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 10,
                    color: AppColors.inkLight,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    entry.location!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.inkLight,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildImageAttachment() {
    // 如果没有图片，使用默认图片
    final imageUrl = entry.image ?? 'https://picsum.photos/seed/${entry.id}/400/300';
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.network(
          imageUrl,
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    moodColor.withValues(alpha: 0.2),
                    moodColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 48,
                  color: moodColor.withValues(alpha: 0.4),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.ink.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (stackCount > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    moodColor.withValues(alpha: 0.15),
                    moodColor.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: moodColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.layers_rounded,
                    size: 12,
                    color: moodColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$stackCount',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: moodColor,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.ink.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onFlipRequest,
              icon: const Icon(Icons.auto_awesome_rounded, size: 18),
              color: moodColor,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              tooltip: '查看 AI 洞察',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPattern() {
    return CustomPaint(
      painter: PatternPainter(moodColor, entry.mood),
    );
  }
}

class PatternPainter extends CustomPainter {
  final Color color;
  final Mood mood;

  PatternPainter(this.color, this.mood);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    switch (mood) {
      case Mood.joy:
        // 放射线
        for (var i = 0; i < 12; i++) {
          canvas.drawLine(
            Offset(size.width / 2, size.height / 2),
            Offset(
              size.width / 2 + 100 * (i % 2 == 0 ? 1 : 0.7) * (i.isEven ? 1 : -1),
              size.height / 2 + 100 * (i % 2 == 0 ? 1 : 0.7) * (i.isOdd ? 1 : -1),
            ),
            paint..strokeWidth = 2,
          );
        }
        break;
      case Mood.calm:
        // 圆点
        for (var x = 0.0; x < size.width; x += 16) {
          for (var y = 0.0; y < size.height; y += 16) {
            canvas.drawCircle(Offset(x, y), 2, paint);
          }
        }
        break;
      case Mood.anxiety:
        // 竖线
        for (var x = 0.0; x < size.width; x += 8) {
          canvas.drawLine(
            Offset(x, 0),
            Offset(x, size.height),
            paint..strokeWidth = 2,
          );
        }
        break;
      case Mood.sadness:
        // 菱形
        for (var x = 0.0; x < size.width; x += 20) {
          for (var y = 0.0; y < size.height; y += 20) {
            final path = Path()
              ..moveTo(x, y - 5)
              ..lineTo(x + 5, y)
              ..lineTo(x, y + 5)
              ..lineTo(x - 5, y)
              ..close();
            canvas.drawPath(path, paint);
          }
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
