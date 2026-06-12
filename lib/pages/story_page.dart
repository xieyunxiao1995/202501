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
  ChapterData(index: '序章', title: '黄巾之乱', name: '序章', year: '184年', plot: '张角三兄弟率黄巾起义，天下大乱', boss: '张角'),
  ChapterData(index: '第一章', title: '桃园结义', name: '第一章', year: '184年', plot: '刘关张桃园结义，共举义兵', boss: '黄巾军'),
  ChapterData(index: '第二章', title: '十常侍乱政', name: '第二章', year: '189年', plot: '宦官弄权，朝纲崩坏', boss: '十常侍'),
  ChapterData(index: '第三章', title: '何进之死', name: '第三章', year: '189年', plot: '何进召诸侯入京反被宦官所杀', boss: '十常侍'),
  ChapterData(index: '第四章', title: '董卓进京', name: '第四章', year: '189年', plot: '董卓率西凉军入洛阳，废少帝', boss: '董卓'),
  ChapterData(index: '第五章', title: '曹操献刀', name: '第五章', year: '189年', plot: '曹操刺董未果，只身逃出洛阳', boss: '董卓'),
  ChapterData(index: '第六章', title: '诸侯讨董', name: '第六章', year: '190年', plot: '十八路诸侯联盟讨伐董卓', boss: '董卓'),
  ChapterData(index: '第七章', title: '温酒斩华雄', name: '第七章', year: '190年', plot: '关羽阵前斩华雄，其酒尚温', boss: '华雄'),
  ChapterData(index: '第八章', title: '三英战吕布', name: '第八章', year: '190年', plot: '刘关张三人在虎牢关合战吕布', boss: '吕布'),
  ChapterData(index: '第九章', title: '火烧洛阳', name: '第九章', year: '190年', plot: '董卓焚洛阳迁都长安', boss: '董卓'),
  ChapterData(index: '第十章', title: '孙坚得玉玺', name: '第十章', year: '191年', plot: '孙坚于洛阳井中获传国玉玺', boss: '孙坚'),
  ChapterData(index: '第十一章', title: '连环计', name: '第十一章', year: '192年', plot: '王允设连环计离间董卓吕布', boss: '董卓'),
  ChapterData(index: '第十二章', title: '吕布杀董卓', name: '第十二章', year: '192年', plot: '吕布受王允之托刺杀董卓', boss: '董卓'),
  ChapterData(index: '第十三章', title: '李郭之乱', name: '第十三章', year: '192年', plot: '李傕郭汜反攻长安杀王允', boss: '李傕'),
  ChapterData(index: '第十四章', title: '曹操救驾', name: '第十四章', year: '196年', plot: '曹操迎献帝迁都许昌', boss: '李傕'),
  ChapterData(index: '第十五章', title: '吕布夺徐州', name: '第十五章', year: '195年', plot: '吕布趁虚袭取徐州', boss: '吕布'),
  ChapterData(index: '第十六章', title: '孙策定江东', name: '第十六章', year: '196年', plot: '小霸王孙策席卷江东六郡', boss: '刘繇'),
  ChapterData(index: '第十七章', title: '辕门射戟', name: '第十七章', year: '196年', plot: '吕布辕门射戟解刘备之围', boss: '纪灵'),
  ChapterData(index: '第十八章', title: '曹操征张绣', name: '第十八章', year: '197年', plot: '曹操南征张绣，典韦战死', boss: '张绣'),
  ChapterData(index: '第十九章', title: '吕布殒命', name: '第十九章', year: '198年', plot: '白门楼吕布被曹操缢杀', boss: '吕布'),
  ChapterData(index: '第二十章', title: '煮酒论英雄', name: '第二十章', year: '199年', plot: '曹操青梅煮酒试探刘备', boss: '剧情章节'),
  ChapterData(index: '第二十一章', title: '衣带诏', name: '第二十一章', year: '200年', plot: '献帝血写密诏令董承除曹', boss: '曹操'),
  ChapterData(index: '第二十二章', title: '斩颜良诛文丑', name: '第二十二章', year: '200年', plot: '关羽于白马延津连斩河北双雄', boss: '颜良'),
  ChapterData(index: '第二十三章', title: '过五关斩六将', name: '第二十三章', year: '200年', plot: '关羽千里走单骑寻兄', boss: '曹操部将'),
  ChapterData(index: '第二十四章', title: '古城相会', name: '第二十四章', year: '200年', plot: '刘关张于古城再聚首', boss: '剧情章节'),
  ChapterData(index: '第二十五章', title: '官渡之战', name: '第二十五章', year: '200年', plot: '曹操袁绍官渡决战', boss: '袁绍'),
  ChapterData(index: '第二十六章', title: '乌巢烧粮', name: '第二十六章', year: '200年', plot: '曹操夜袭乌巢焚袁军粮草', boss: '淳于琼'),
  ChapterData(index: '第二十七章', title: '袁绍败亡', name: '第二十七章', year: '202年', plot: '袁绍兵败官渡，不久郁郁而终', boss: '袁绍'),
  ChapterData(index: '第二十八章', title: '平定河北', name: '第二十八章', year: '205年', plot: '曹操逐一消灭袁绍诸子', boss: '袁谭'),
  ChapterData(index: '第二十九章', title: '徐庶荐诸葛', name: '第二十九章', year: '207年', plot: '徐庶临走前向刘备举荐卧龙', boss: '剧情章节'),
  ChapterData(index: '第三十章', title: '三顾茅庐', name: '第三十章', year: '207年', plot: '刘备三访隆中请诸葛亮出山', boss: '剧情章节'),
  ChapterData(index: '第三十一章', title: '隆中对', name: '第三十一章', year: '207年', plot: '诸葛亮隆中献策三分天下', boss: '剧情章节'),
  ChapterData(index: '第三十二章', title: '博望坡之战', name: '第三十二章', year: '207年', plot: '诸葛亮初出茅庐火烧博望坡', boss: '夏侯惇'),
  ChapterData(index: '第三十三章', title: '火烧新野', name: '第三十三章', year: '208年', plot: '诸葛亮再施火计大败曹仁', boss: '曹仁'),
  ChapterData(index: '第三十四章', title: '长坂坡救主', name: '第三十四章', year: '208年', plot: '赵云七进七出救阿斗', boss: '曹操'),
  ChapterData(index: '第三十五章', title: '当阳桥断后', name: '第三十五章', year: '208年', plot: '张飞独守当阳桥喝退曹军', boss: '曹操'),
  ChapterData(index: '第三十六章', title: '舌战群儒', name: '第三十六章', year: '208年', plot: '诸葛亮过江辩倒江东主和派', boss: '剧情章节'),
  ChapterData(index: '第三十七章', title: '草船借箭', name: '第三十七章', year: '208年', plot: '诸葛亮借大雾草船骗曹军箭矢', boss: '曹操'),
  ChapterData(index: '第三十八章', title: '苦肉计', name: '第三十八章', year: '208年', plot: '黄盖受鞭刑诈降曹操', boss: '剧情章节'),
  ChapterData(index: '第三十九章', title: '借东风', name: '第三十九章', year: '208年', plot: '诸葛亮登坛作法借来东南风', boss: '剧情章节'),
  ChapterData(index: '第四十章', title: '火烧赤壁', name: '第四十章', year: '208年', plot: '黄盖火船冲阵大破曹军', boss: '曹操'),
  ChapterData(index: '第四十一章', title: '华容道', name: '第四十一章', year: '208年', plot: '关羽华容道义释曹操', boss: '曹操'),
  ChapterData(index: '第四十二章', title: '智取南郡', name: '第四十二章', year: '209年', plot: '诸葛亮用计夺取南郡', boss: '曹仁'),
  ChapterData(index: '第四十三章', title: '三气周瑜', name: '第四十三章', year: '209年', plot: '周瑜屡次受挫于诸葛亮', boss: '周瑜'),
  ChapterData(index: '第四十四章', title: '凤雏理政', name: '第四十四章', year: '210年', plot: '庞统出任耒阳县令百日理政', boss: '剧情章节'),
  ChapterData(index: '第四十五章', title: '马超起兵', name: '第四十五章', year: '211年', plot: '马超为父报仇起兵反曹', boss: '曹操'),
  ChapterData(index: '第四十六章', title: '许褚斗马超', name: '第四十六章', year: '211年', plot: '许褚裸衣与马超大战', boss: '马超'),
  ChapterData(index: '第四十七章', title: '刘备入川', name: '第四十七章', year: '211年', plot: '刘备应刘璋之邀率兵入蜀', boss: '刘璋'),
  ChapterData(index: '第四十八章', title: '落凤坡', name: '第四十八章', year: '214年', plot: '庞统于落凤坡中箭身亡', boss: '张任'),
  ChapterData(index: '第四十九章', title: '义释严颜', name: '第四十九章', year: '214年', plot: '张飞用计生擒并义释老将严颜', boss: '严颜'),
  ChapterData(index: '第五十章', title: '马超归刘', name: '第五十章', year: '214年', plot: '马超兵败后投奔刘备', boss: '剧情章节'),
  ChapterData(index: '第五十一章', title: '刘璋归降', name: '第五十一章', year: '214年', plot: '刘璋开城降刘，刘备得益州', boss: '刘璋'),
  ChapterData(index: '第五十二章', title: '逍遥津之战', name: '第五十二章', year: '215年', plot: '张辽八百精骑大破孙权十万兵', boss: '孙权'),
  ChapterData(index: '第五十三章', title: '曹操收汉中', name: '第五十三章', year: '215年', plot: '曹操率军攻灭张鲁取汉中', boss: '张鲁'),
  ChapterData(index: '第五十四章', title: '定军山', name: '第五十四章', year: '219年', plot: '刘备军与夏侯渊决战定军山', boss: '夏侯渊'),
  ChapterData(index: '第五十五章', title: '黄忠斩夏侯', name: '第五十五章', year: '219年', plot: '老将黄忠阵斩夏侯渊', boss: '夏侯渊'),
  ChapterData(index: '第五十六章', title: '子龙一身胆', name: '第五十六章', year: '219年', plot: '赵云空营退敌，曹操叹服', boss: '曹操'),
  ChapterData(index: '第五十七章', title: '刘备称王', name: '第五十七章', year: '219年', plot: '刘备于沔阳自称汉中王', boss: '剧情章节'),
  ChapterData(index: '第五十八章', title: '水淹七军', name: '第五十八章', year: '219年', plot: '关羽掘汉水淹于禁七军', boss: '于禁'),
  ChapterData(index: '第五十九章', title: '走麦城', name: '第五十九章', year: '219年', plot: '关羽败走麦城被孙权擒杀', boss: '吕蒙'),
  ChapterData(index: '第六十章', title: '曹操之死', name: '第六十章', year: '220年', plot: '一代枭雄曹操病逝洛阳', boss: '剧情章节'),
  ChapterData(index: '第六十一章', title: '曹丕篡汉', name: '第六十一章', year: '220年', plot: '曹丕废献帝自立，建立魏国', boss: '剧情章节'),
  ChapterData(index: '第六十二章', title: '刘备称帝', name: '第六十二章', year: '221年', plot: '刘备于成都即皇帝位', boss: '剧情章节'),
  ChapterData(index: '第六十三章', title: '张飞遇害', name: '第六十三章', year: '221年', plot: '张飞被部将范疆张达刺杀', boss: '范疆张达'),
  ChapterData(index: '第六十四章', title: '夷陵之战', name: '第六十四章', year: '222年', plot: '刘备倾国伐吴，陆逊坚守不战', boss: '孙权'),
  ChapterData(index: '第六十五章', title: '火烧连营', name: '第六十五章', year: '222年', plot: '陆逊火烧蜀营连营七百里', boss: '陆逊'),
  ChapterData(index: '第六十六章', title: '白帝托孤', name: '第六十六章', year: '223年', plot: '刘备病危将刘禅托付诸葛亮', boss: '剧情章节'),
  ChapterData(index: '第六十七章', title: '七擒孟获', name: '第六十七章', year: '225年', plot: '诸葛亮南征七擒七纵孟获', boss: '孟获'),
  ChapterData(index: '第六十八章', title: '出师表', name: '第六十八章', year: '227年', plot: '诸葛亮上出师表北伐曹魏', boss: '剧情章节'),
  ChapterData(index: '第六十九章', title: '收姜维', name: '第六十九章', year: '228年', plot: '诸葛亮智降天水姜维', boss: '姜维'),
  ChapterData(index: '第七十章', title: '失街亭', name: '第七十章', year: '228年', plot: '马谡失守街亭，诸葛亮挥泪斩之', boss: '张郃'),
  ChapterData(index: '第七十一章', title: '空城计', name: '第七十一章', year: '228年', plot: '诸葛亮空城弹琴退司马懿', boss: '司马懿'),
  ChapterData(index: '第七十二章', title: '六出祁山', name: '第七十二章', year: '228年', plot: '诸葛亮先后六次出祁山伐魏', boss: '司马懿'),
  ChapterData(index: '第七十三章', title: '木牛流马', name: '第七十三章', year: '231年', plot: '诸葛亮发明木牛流马运粮', boss: '司马懿'),
  ChapterData(index: '第七十四章', title: '上方谷', name: '第七十四章', year: '234年', plot: '诸葛亮上方谷火困司马懿', boss: '司马懿'),
  ChapterData(index: '第七十五章', title: '五丈原', name: '第七十五章', year: '234年', plot: '诸葛亮病逝五丈原，将星陨落', boss: '司马懿'),
  ChapterData(index: '第七十六章', title: '姜维北伐', name: '第七十六章', year: '238年', plot: '姜维继承遗志先后九次北伐', boss: '邓艾'),
  ChapterData(index: '第七十七章', title: '偷渡阴平', name: '第七十七章', year: '263年', plot: '邓艾奇袭阴平直逼成都', boss: '邓艾'),
  ChapterData(index: '第七十八章', title: '蜀汉灭亡', name: '第七十八章', year: '263年', plot: '刘禅出降，蜀汉历二帝而亡', boss: '邓艾'),
  ChapterData(index: '第七十九章', title: '三家归晋', name: '第七十九章', year: '280年', plot: '司马炎统一天下，三国终结', boss: '司马炎'),
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

