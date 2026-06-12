import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../story_page.dart';

class ChapterCampaignPage extends StatelessWidget {
  const ChapterCampaignPage({super.key, required this.chapterId});

  final String chapterId;

  ChapterData get _chapter {
    final index = int.tryParse(chapterId) ?? 0;
    final safeIndex = index.clamp(0, kChapters.length - 1);
    return kChapters[safeIndex];
  }

  List<_CampaignStageData> get _stages => _buildCampaignStages(_chapter, chapterId);

  @override
  Widget build(BuildContext context) {
    final chapter = _chapter;
    final stages = _stages;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/ui/story_bg.png', fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xD9160E0A), Color(0xF219120D)],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _CampaignHeader(chapter: chapter, stageCount: stages.length),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  sliver: SliverList.separated(
                    itemCount: stages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final stage = stages[index];
                      return _StageNodeCard(
                        stage: stage,
                        onTap: () {
                          context.pushNamed(
                            'stageDetail',
                            pathParameters: {
                              'chapterId': chapterId,
                              'stageId': stage.id,
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StageDetailPage extends StatelessWidget {
  const StageDetailPage({super.key, required this.chapterId, required this.stageId});

  final String chapterId;
  final String stageId;

  ChapterData get _chapter {
    final index = int.tryParse(chapterId) ?? 0;
    final safeIndex = index.clamp(0, kChapters.length - 1);
    return kChapters[safeIndex];
  }

  _CampaignStageData get _stage {
    final stages = _buildCampaignStages(_chapter, chapterId);
    return stages.firstWhere(
      (item) => item.id == stageId,
      orElse: () => stages.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapter = _chapter;
    final stage = _stage;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/ui/story_bg.png', fit: BoxFit.cover),
          Container(color: const Color(0xE617100C)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(title: '关卡详情', onBack: () => context.pop()),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: _panelDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title,
                          style: const TextStyle(
                            color: Color(0xFFE6D3A4),
                            fontSize: 14,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          stage.name,
                          style: const TextStyle(
                            color: Color(0xFFF5EAD7),
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          stage.summary,
                          style: const TextStyle(
                            color: Color(0xCCF0E4CF),
                            fontSize: 15,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _InfoBadge(label: '敌军主将', value: stage.enemyName),
                            _InfoBadge(label: '推荐战力', value: '${stage.recommendedPower}'),
                            _InfoBadge(label: '首通奖励', value: stage.rewardLabel),
                            _InfoBadge(label: '关卡类型', value: stage.typeLabel),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: _panelDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '战前目标',
                          style: TextStyle(
                            color: Color(0xFFE6D3A4),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...stage.objectives.map(
                          (objective) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Icon(
                                    Icons.gpp_good_rounded,
                                    color: Color(0xFFD4A84B),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    objective,
                                    style: const TextStyle(
                                      color: Color(0xFFE7DCC8),
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA11717),
                        foregroundColor: const Color(0xFFF7EEDF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: Color(0x66D4A84B)),
                        ),
                      ),
                      onPressed: () => context.pushNamed('recruit'),
                      child: const Text(
                        '整军出战',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignHeader extends StatelessWidget {
  const _CampaignHeader({required this.chapter, required this.stageCount});

  final ChapterData chapter;
  final int stageCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopBar(title: '章节征战', onBack: () => context.pop()),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: _panelDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chapter.index,
                style: const TextStyle(
                  color: Color(0xFFD4A84B),
                  fontSize: 13,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                chapter.title,
                style: const TextStyle(
                  color: Color(0xFFF5EBD8),
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${chapter.year} · ${chapter.plot}',
                style: const TextStyle(
                  color: Color(0xCCE6D8C1),
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryTile(label: '战役节点', value: '$stageCount'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryTile(label: '章末敌首', value: chapter.boss),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: _SummaryTile(label: '首通目标', value: '全关平定'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0x24FFFFFF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFFF6EAD7),
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF6EAD7),
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StageNodeCard extends StatelessWidget {
  const _StageNodeCard({required this.stage, required this.onTap});

  final _CampaignStageData stage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: _panelDecoration(),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4A84B), Color(0xFF8B5A1D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                stage.shortLabel,
                style: const TextStyle(
                  color: Color(0xFF2F1508),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stage.name,
                          style: const TextStyle(
                            color: Color(0xFFF5EAD8),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0x26D4A84B),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0x44D4A84B)),
                        ),
                        child: Text(
                          stage.typeLabel,
                          style: const TextStyle(
                            color: Color(0xFFE7CE8C),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stage.summary,
                    style: const TextStyle(
                      color: Color(0xCCE2D7C3),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '敌首 ${stage.enemyName}',
                        style: const TextStyle(
                          color: Color(0xFFD4A84B),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '推荐 ${stage.recommendedPower}',
                        style: const TextStyle(
                          color: Color(0xFFBFB09A),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFE6D3A4),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x221E1813),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x26D4A84B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0x99E5D9C5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFF5EBD8),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x26D4A84B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x44D4A84B)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label  ',
              style: const TextStyle(
                color: Color(0xFFBAA98D),
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Color(0xFFF5EBD8),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignStageData {
  const _CampaignStageData({
    required this.id,
    required this.order,
    required this.name,
    required this.typeLabel,
    required this.summary,
    required this.enemyName,
    required this.recommendedPower,
    required this.rewardLabel,
    required this.objectives,
  });

  final String id;
  final int order;
  final String name;
  final String typeLabel;
  final String summary;
  final String enemyName;
  final int recommendedPower;
  final String rewardLabel;
  final List<String> objectives;

  String get shortLabel => '${order + 1}';
}

List<_CampaignStageData> _buildCampaignStages(ChapterData chapter, String chapterId) {
  final basePower = 1800 + ((int.tryParse(chapterId) ?? 0) * 120);
  final bossName = chapter.boss == '剧情章节' ? '宿卫军' : chapter.boss;

  return [
    _CampaignStageData(
      id: '${chapterId}_vanguard',
      order: 0,
      name: '前锋遭遇',
      typeLabel: '普通战',
      summary: '敌军前哨已经布下阵势，先破其锋锐，才能为主力开出进军道路。',
      enemyName: '${bossName}前锋',
      recommendedPower: basePower,
      rewardLabel: '铜钱 x800',
      objectives: const [
        '击溃敌军前锋，打开本章第一道战线。',
        '尽量保证主将血量稳定，为后续恶战保存状态。',
      ],
    ),
    _CampaignStageData(
      id: '${chapterId}_midline',
      order: 1,
      name: '中军突进',
      typeLabel: '精英战',
      summary: '敌军中阵设伏，若不能正面压穿，章末主战便会陷入被动。',
      enemyName: '精英将 · ${chapter.title}',
      recommendedPower: basePower + 400,
      rewardLabel: '装备残卷 x2',
      objectives: const [
        '优先处理敌方高伤单位，避免我方后排快速减员。',
        '稳住阵型后推进，为决战积累信心与节奏。',
      ],
    ),
    _CampaignStageData(
      id: '${chapterId}_boss',
      order: 2,
      name: '章末决战',
      typeLabel: '首领战',
      summary: '敌首已现身阵前，此战若胜，便可平定本章乱局，改写局势。',
      enemyName: bossName,
      recommendedPower: basePower + 900,
      rewardLabel: '将魂 x30',
      objectives: [
        '击败 $bossName，完成本章征战。',
        '若能保持多名武将存活，将更容易拿到后续三星目标。',
      ],
    ),
  ];
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: const Color(0xCC1D1712),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: const Color(0x33D4A84B)),
    boxShadow: const [
      BoxShadow(
        color: Color(0x44000000),
        blurRadius: 18,
        offset: Offset(0, 10),
      ),
    ],
  );
}