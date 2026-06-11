import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 剧情章节数据
class ChapterData {
  const ChapterData({
    required this.index,
    required this.title,
    required this.name,
    required this.year,
    required this.plot,
    required this.boss,
  });

  final String index; // 序章 / 第一章 ...
  final String title; // 黄巾之乱
  final String name; // 序章 / 第一章 合并展示名
  final String year; // 184年
  final String plot; // 核心剧情描述
  final String boss; // 标志性 BOSS

  /// 是否为纯剧情章节（无 BOSS 战）
  bool get isStoryOnly => boss == '剧情章节';
}

/// 剧情主线 16 个章节
const kChapters = <ChapterData>[
  ChapterData(index: '序章', title: '黄巾之乱', name: '序章', year: '184年', plot: '黄巾起义，玩家初出茅庐', boss: '张角'),
  ChapterData(index: '第一章', title: '十常侍乱政', name: '第一章', year: '189年', plot: '朝堂倾轧，何进被杀', boss: '十常侍'),
  ChapterData(index: '第二章', title: '董卓进京', name: '第二章', year: '189年', plot: '废立皇帝，火烧洛阳', boss: '董卓、吕布'),
  ChapterData(index: '第三章', title: '十八路诸侯讨董', name: '第三章', year: '190年', plot: '虎牢关前会群雄', boss: '吕布（虎牢关）'),
  ChapterData(index: '第四章', title: '群雄割据', name: '第四章', year: '191-194年', plot: '诸侯混战，争夺地盘', boss: '多个诸侯'),
  ChapterData(index: '第五章', title: '衣带诏', name: '第五章', year: '200年', plot: '曹操挟天子以令诸侯', boss: '曹操'),
  ChapterData(index: '第六章', title: '官渡之战', name: '第六章', year: '200年', plot: '曹袁决战', boss: '袁绍'),
  ChapterData(index: '第七章', title: '三顾茅庐', name: '第七章', year: '207年', plot: '刘备得诸葛亮', boss: '剧情章节'),
  ChapterData(index: '第八章', title: '赤壁之战', name: '第八章', year: '208年', plot: '孙刘联合抗曹', boss: '曹操水军'),
  ChapterData(index: '第九章', title: '入主西川', name: '第九章', year: '211-214年', plot: '刘备夺益州', boss: '刘璋、张鲁'),
  ChapterData(index: '第十章', title: '汉中之战', name: '第十章', year: '219年', plot: '刘曹争汉中', boss: '夏侯渊、曹操'),
  ChapterData(index: '第十一章', title: '荆州之失', name: '第十一章', year: '219年', plot: '关羽走麦城', boss: '吕蒙、陆逊'),
  ChapterData(index: '第十二章', title: '夷陵之战', name: '第十二章', year: '222年', plot: '刘备伐吴', boss: '陆逊'),
  ChapterData(index: '第十三章', title: '七擒孟获', name: '第十三章', year: '225年', plot: '诸葛亮南征', boss: '孟获'),
  ChapterData(index: '第十四章', title: '六出祁山', name: '第十四章', year: '228-234年', plot: '诸葛北伐', boss: '司马懿'),
  ChapterData(index: '第十五章', title: '三家归晋', name: '第十五章', year: '280年', plot: '历史终章', boss: '司马炎'),
];

/// 剧情页面
///
/// 底部导航栏"剧情"标签对应的界面。
/// 展示三国剧情主线 15 个章节，每章包含时间、剧情、BOSS 等信息。
class StoryPage extends StatelessWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/story_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- 顶部标题 ----
              const _StoryHeader(),
              // ---- 章节列表 ----
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: kChapters.length,
                  itemBuilder: (context, index) {
                    return _ChapterCard(
                      chapter: kChapters[index],
                      chapterIndex: index,
                      isLast: index == kChapters.length - 1,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 顶部标题 ====================

class _StoryHeader extends StatelessWidget {
  const _StoryHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '剧情主线',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE2D9CD),
              letterSpacing: 6,
              shadows: [
                Shadow(
                  color: Color(0xCC7A0D0D),
                  blurRadius: 8,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 80,
            height: 1.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Color(0x99A11717), Colors.transparent],
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '纵观三国 · 逐鹿天下',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 4,
              color: Color.fromARGB(153, 159, 37, 37),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 章节卡片 ====================

class _ChapterCard extends StatefulWidget {
  const _ChapterCard({
    required this.chapter,
    required this.chapterIndex,
    required this.isLast,
  });

  final ChapterData chapter;
  final int chapterIndex;
  final bool isLast;

  @override
  State<_ChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends State<_ChapterCard> {
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.isLast ? 16 : 10),
      child: Container(
        key: _cardKey,
        decoration: BoxDecoration(
          color: const Color(0xCC1A1A2A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0x306A0F0F),
            width: 0.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _onChapterTap(context),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // ---- 左侧：章节序号圆圈 ----
                  _ChapterBadge(index: widget.chapter.index),
                  const SizedBox(width: 14),
                  // ---- 中间：章节信息 ----
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题行：章节名 + 年份
                        Row(
                          children: [
                            Text(
                              widget.chapter.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE2D9CD),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0x30A11717),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                widget.chapter.year,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xCCA11717),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // 剧情描述
                        Text(
                          widget.chapter.plot,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0x998B7E6A),
                            height: 1.4,
                          ),
                        ),
                        if (!widget.chapter.isStoryOnly) ...[
                          const SizedBox(height: 6),
                          // BOSS 标签
                          Row(
                            children: [
                              const Icon(Icons.gavel, size: 13, color: Color(0x99A11717)),
                              const SizedBox(width: 4),
                              Text(
                                'BOSS: ${widget.chapter.boss}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xCCA11717),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.menu_book, size: 13, color: Color(0x997A8B6E)),
                              const SizedBox(width: 4),
                              const Text(
                                '纯剧情章节',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0x997A8B6E),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // ---- 右侧：箭头 ----
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0x406A0F0F),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onChapterTap(BuildContext context) {
    // 获取当前 item 在屏幕上的矩形区域，用于展开过渡动画
    final renderBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero);
    final rect = offset != null && renderBox != null
        ? offset & renderBox.size
        : null;

    GoRouter.of(context).pushNamed(
      'storyChapter',
      pathParameters: {'chapterIndex': widget.chapterIndex.toString()},
      extra: rect,
    );
  }
}

// ==================== 章节序号徽章 ====================

class _ChapterBadge extends StatelessWidget {
  const _ChapterBadge({required this.index});

  final String index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA11717), Color(0xFF6A0F0F)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30A11717),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        index,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFFE2D9CD),
        ),
      ),
    );
  }
}

