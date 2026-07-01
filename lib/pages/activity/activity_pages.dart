import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_paths.dart';

const _bgGift = 'assets/Bg/Bg1.png';
const _bgDaily = 'assets/Bg/Bg6.png';
const _bgSignIn = 'assets/Bg/Bg5.png';
const _bgWorld = 'assets/Bg/Bg6.png';

const _iconRecruit = 'assets/UI/icon_0001.png';
const _iconJade = 'assets/UI/icon_0004.png';
const _iconCoin = 'assets/UI/icon_0006.png';
const _iconIngot = 'assets/UI/icon_0009.png';
const _iconChest = 'assets/UI/icon_0010.png';
const _iconBag = 'assets/UI/icon_0011.png';
const _iconBack = 'assets/UI/icon_0028.png';
const _iconVip = 'assets/UI/icon_0029.png';
const _iconRank = 'assets/UI/icon_0031.png';
const _iconToken = 'assets/UI/icon_0047.png';
const _iconBlueOrb = 'assets/UI/icon_0042.png';
const _iconPurpleCard = 'assets/UI/icon_0043.png';
const _iconFrameBlue = 'assets/UI/icon_0077.png';
const _iconFramePurple = 'assets/UI/icon_0078.png';

class ActivityHubPage extends StatelessWidget {
  const ActivityHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _EventScaffold(
      background: _bgWorld,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const _TopResourceBar(title: '活动中心'),
            const SizedBox(height: 18),
            _HubCard(
              title: '日常活跃',
              subtitle: '完成每日目标，领取活跃战令奖励',
              background: _bgDaily,
              icon: _iconRecruit,
              onTap: () => context.push(RoutePaths.dailyQuest),
            ),
            _HubCard(
              title: '每日签到',
              subtitle: '连续签到获得元宝、招募令与稀有道具',
              background: _bgSignIn,
              icon: _iconChest,
              onTap: () => context.push('/activities/sign-in'),
            ),
            _HubCard(
              title: '限时大礼包',
              subtitle: '限时折扣礼包，大礼盒放送',
              background: _bgGift,
              icon: _iconIngot,
              onTap: () => context.push('/activities/limited/gift'),
            ),
            _HubCard(
              title: '通关世界童节',
              subtitle: '推进章节，领取通关招募会奖励',
              background: _bgWorld,
              icon: _iconRank,
              onTap: () => context.push('/activities/world-recruit'),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyActivityPage extends StatefulWidget {
  const DailyActivityPage({super.key});

  @override
  State<DailyActivityPage> createState() => _DailyActivityPageState();
}

class _DailyActivityPageState extends State<DailyActivityPage> {
  final List<_DailyTask> _tasks = [
    _DailyTask('通天塔挑战3次', '3/3', 1, _iconJade, '20', true),
    _DailyTask('诛魔卫道挑战1次', '1/1', 1, _iconJade, '20', true),
    _DailyTask('任意商铺购买1次', '0/1', 0, _iconCoin, '20000', false),
    _DailyTask('招募1次', '0/1', 0, _iconIngot, '20', false),
  ];

  void _claimTask(int index) {
    final task = _tasks[index];
    if (!task.claimable || task.claimed) return;
    setState(() {
      task.claimed = true;
      task.claimable = false;
    });
    _showClaimDialog(task);
  }

  void _claimAll() {
    final claimableTasks = _tasks.where((t) => t.claimable && !t.claimed).toList();
    if (claimableTasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无可领取的奖励')),
      );
      return;
    }
    setState(() {
      for (final task in claimableTasks) {
        task.claimed = true;
        task.claimable = false;
      }
    });
    _showClaimAllDialog(claimableTasks);
  }

  void _showClaimDialog(_DailyTask task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('领取成功'),
        content: Row(
          children: [
            Image.asset(task.icon, width: 40, height: 40),
            const SizedBox(width: 12),
            Text('x${task.amount}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showClaimAllDialog(List<_DailyTask> tasks) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('一键领取成功'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tasks.map((t) => Row(
            children: [
              Image.asset(t.icon, width: 30, height: 30),
              const SizedBox(width: 8),
              Text('x${t.amount}', style: const TextStyle(fontSize: 16)),
            ],
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _goToTask(_DailyTask task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('前往：${task.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EventScaffold(
      background: _bgDaily,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: _TopResourceBar(title: '日常活跃', compact: true),
            ),
            SizedBox(
              height: 236,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xCC11192A)],
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 22,
                    bottom: 22,
                    child: _ActivityToken(icon: _iconRecruit, value: '20/100'),
                  ),

                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E5ED),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(8, 18, 8, 10),
                        itemCount: _tasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            _DailyTaskTile(
                              task: _tasks[index],
                              onClaim: () => _claimTask(index),
                              onGo: () => _goToTask(_tasks[index]),
                            ),
                      ),
                    ),
                    _DailyClaimBar(onClaimAll: _claimAll),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailySignInPage extends StatefulWidget {
  const DailySignInPage({super.key});

  @override
  State<DailySignInPage> createState() => _DailySignInPageState();
}

class _DailySignInPageState extends State<DailySignInPage> {
  // 累计签到天数
  int _totalSignInDays = 3;
  // 连续签到天数
  int _consecutiveDays = 3;
  // 今天是否已签到
  bool _signedInToday = false;
  // 已领取的奖励索引
  final Set<int> _claimedRewards = {0, 1};

  static const _rewards = [
    _Reward(_iconIngot, '50', '第1日'),
    _Reward(_iconPurpleCard, '15', '第2日'),
    _Reward(_iconIngot, '50', '第3日'),
    _Reward(_iconRecruit, '1', '第4日'),
    _Reward(_iconRank, '5', '第5日'),
    _Reward(_iconPurpleCard, '15', '第6日'),
    _Reward(_iconIngot, '50', '第7日'),
    _Reward(_iconIngot, '100', '第8日'),
    _Reward(_iconRecruit, '2', '第9日'),
    _Reward(_iconRank, '10', '第10日'),
    _Reward(_iconIngot, '50', '第11日'),
    _Reward(_iconPurpleCard, '30', '第12日'),
    _Reward(_iconIngot, '100', '第13日'),
    _Reward(_iconRecruit, '2', '第14日'),
    _Reward(_iconRank, '15', '第15日'),
    _Reward(_iconIngot, '200', '第16日'),
    _Reward(_iconPurpleCard, '50', '第17日'),
    _Reward(_iconRecruit, '3', '第18日'),
    _Reward(_iconRank, '20', '第19日'),
    _Reward(_iconIngot, '500', '第20日'),
  ];

  // 连续签到里程碑奖励
  static const _milestones = [
    _Milestone(1, _iconIngot, '50', '签到1天'),
    _Milestone(3, _iconPurpleCard, '15', '连续3天'),
    _Milestone(5, _iconIngot, '100', '连续5天'),
    _Milestone(7, _iconRecruit, '2', '连续7天'),
  ];

  void _doSignIn() {
    if (_signedInToday) return;
    setState(() {
      _signedInToday = true;
      _totalSignInDays++;
      _consecutiveDays++;
      // 自动领取当日奖励
      final todayIndex = (_totalSignInDays - 1) % _rewards.length;
      _claimedRewards.add(todayIndex);
    });
    _showSignInDialog(_rewards[(_totalSignInDays - 1) % _rewards.length]);
  }

  void _claimReward(int index) {
    if (_claimedRewards.contains(index)) return;
    // 只有累计签到天数达到的奖励才能领取
    if (index >= _totalSignInDays) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('还未达到该奖励的领取条件')),
      );
      return;
    }
    setState(() {
      _claimedRewards.add(index);
    });
    _showClaimRewardDialog(_rewards[index]);
  }

  void _claimMilestone(_Milestone milestone) {
    if (_consecutiveDays < milestone.requiredDays) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('需要连续签到${milestone.requiredDays}天')),
      );
      return;
    }
    _showClaimRewardDialog(
      _Reward(milestone.icon, milestone.amount, milestone.label),
    );
  }

  void _showSignInDialog(_Reward reward) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('签到成功'),
        content: Row(
          children: [
            Image.asset(reward.icon, width: 40, height: 40),
            const SizedBox(width: 12),
            Text(
              'x${reward.amount}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showClaimRewardDialog(_Reward reward) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('领取成功'),
        content: Row(
          children: [
            Image.asset(reward.icon, width: 40, height: 40),
            const SizedBox(width: 12),
            Text(
              'x${reward.amount}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EventScaffold(
      background: _bgSignIn,
      child: SafeArea(
        child: Row(
          children: [
            const _SignInSideRail(),
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: _TopResourceBar(title: '', showBack: false),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                      children: [
                        const Text(
                          '每日签到',
                          style: TextStyle(
                            color: Color(0xFFFFF0A6),
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(color: Color(0xFFE03D28), blurRadius: 8),
                              Shadow(
                                color: Color(0xFF8A1E10),
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        // 签到信息栏
                        _SignInInfoBar(
                          totalDays: _totalSignInDays,
                          consecutiveDays: _consecutiveDays,
                          signedInToday: _signedInToday,
                          onSignIn: _doSignIn,
                        ),
                        const SizedBox(height: 12),
                        // 连续签到里程碑
                        _SignInMilestones(
                          milestones: _milestones,
                          consecutiveDays: _consecutiveDays,
                          onClaim: _claimMilestone,
                        ),
                        const SizedBox(height: 12),
                        // 签到奖励列表
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = constraints.maxWidth > 420 ? 5 : 4;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _rewards.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 0.86,
                                  ),
                              itemBuilder: (context, index) => _RewardTile(
                                reward: _rewards[index],
                                claimed: _claimedRewards.contains(index),
                                claimable: index < _totalSignInDays,
                                onTap: () => _claimReward(index),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LimitedGiftPage extends StatelessWidget {
  const LimitedGiftPage({super.key});

  static const _packs = [
    _GiftPack('超值秘籍礼包', _iconIngot, 500, [
      _Reward(_iconIngot, '180', ''),
      _Reward(_iconChest, '5', ''),
      _Reward(_iconChest, '5', ''),
      _Reward(_iconChest, '5', ''),
    ]),
    _GiftPack('豪华招募礼包', _iconIngot, 800, [
      _Reward(_iconIngot, '300', ''),
      _Reward(_iconRecruit, '30', ''),
      _Reward(_iconRecruit, '30', ''),
      _Reward(_iconRecruit, '30', ''),
    ]),
    _GiftPack('豪华秘籍礼包', _iconIngot, 1000, [
      _Reward(_iconIngot, '300', ''),
      _Reward(_iconBag, '5', ''),
      _Reward(_iconChest, '5', ''),
      _Reward(_iconChest, '5', ''),
    ]),
    _GiftPack('战力进阶礼包', _iconIngot, 2000, [
      _Reward(_iconIngot, '680', ''),
      _Reward(_iconBlueOrb, '200万', ''),
      _Reward(_iconJade, '2880', ''),
      _Reward(_iconJade, '2880', ''),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return _EventScaffold(
      background: _bgGift,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: _TopResourceBar(title: '限时礼包', compact: true),
            ),
            Container(
              height: 284,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 70, 16, 0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '限时大礼包',
                    style: TextStyle(
                      color: Color(0xFFFFF3A4),
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Color(0xFFFF532E), blurRadius: 8),
                        Shadow(color: Color(0xFFB63227), offset: Offset(1, 2)),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '元宝兑换，大礼包放送',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '活动期间，使用元宝兑换超值礼包！',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  _TimePill(text: '剩余时间：3天13时'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE9EAF0),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  itemCount: _packs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) =>
                      _GiftPackTile(pack: _packs[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorldRecruitEventPage extends StatelessWidget {
  const WorldRecruitEventPage({super.key});

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1930),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '活动规则',
          style: TextStyle(
            color: Color(0xFFFFF1A8),
            fontWeight: FontWeight.w900,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '1. 活动期间，通关指定章节关卡即可获得对应奖励。\n'
            '2. 每个关卡奖励仅限领取一次，不可重复领取。\n'
            '3. 通关奖励将自动发放至背包。\n'
            '4. 活动最终解释权归官方所有。',
            style: TextStyle(color: Color(0xFFCCCCDD), fontSize: 14, height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              '我知道了',
              style: TextStyle(color: Color(0xFF7B8CFF)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EventScaffold(
      background: _bgWorld,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 6, 12, 0),
                  child: _TopResourceBar(title: '', compact: true),
                ),
                const Spacer(),
                Container(
                  height: 138,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xE9111020)],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 18,
              right: 18,
              top: 244,
              child: Column(
                children: [
                  const Text(
                    '通关世界童节',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE9ECFF),
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Color(0xFF776BFF), blurRadius: 8),
                        Shadow(color: Color(0xFFFFFFFF), blurRadius: 2),
                      ],
                    ),
                  ),
                  const Text(
                    '送海量招募会',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFF1A8),
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Color(0xFFFF5C2C), blurRadius: 8),
                        Shadow(color: Color(0xFFFFFFFF), blurRadius: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _WorldRewardBanner(
                          icon: _iconIngot,
                          count: 'x50',
                          chapter: '第1章',
                          stage: '通关1-7',
                          onTap: () => _showRulesDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _WorldRewardBanner(
                          icon: _iconRecruit,
                          count: 'x10',
                          chapter: '第1章',
                          stage: '通关1-7',
                          tall: true,
                          onTap: () => _showRulesDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _WorldRewardBanner(
                          icon: _iconRecruit,
                          count: 'x5',
                          chapter: '第2章',
                          stage: '通关2-10',
                          onTap: () => _showRulesDialog(context),
                        ),
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
}

class _DailyTask {
  _DailyTask(
    this.title,
    this.progress,
    this.ratio,
    this.icon,
    this.amount,
    this.claimable, {
    this.claimed = false,
  });

  final String title;
  final String progress;
  final double ratio;
  final String icon;
  final String amount;
  bool claimable;
  bool claimed;
}

class _Reward {
  const _Reward(this.icon, this.amount, this.label);

  final String icon;
  final String amount;
  final String label;
}

class _GiftPack {
  const _GiftPack(this.title, this.costIcon, this.costAmount, this.rewards,
      {this.limit = 2, this.purchased = 0});

  final String title;
  final String costIcon; // 兑换消耗的主要道具图标
  final int costAmount; // 兑换消耗数量
  final List<_Reward> rewards;
  final int limit; // 限购次数
  final int purchased; // 已购次数
}

class _EventScaffold extends StatelessWidget {
  const _EventScaffold({required this.background, required this.child});

  final String background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(background, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x22101018), Color(0xAA101018)],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _TopResourceBar extends StatelessWidget {
  const _TopResourceBar({
    required this.title,
    this.showBack = true,
    this.compact = false,
  });

  final String title;
  final bool showBack;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          _ImageButton(icon: _iconBack, onTap: () => _popOrHome(context))
        else
          const SizedBox(width: 42),
        if (title.isNotEmpty) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: const Color(0xFFF7EBD8),
                fontSize: compact ? 17 : 22,
                fontWeight: FontWeight.w900,
                shadows: const [Shadow(color: Colors.black, blurRadius: 5)],
              ),
            ),
          ),
        ] else
          const Spacer(),
      ],
    );
  }
}

class _HubCard extends StatelessWidget {
  const _HubCard({
    required this.title,
    required this.subtitle,
    required this.background,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String background;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Ink(
            height: 132,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: const Color(0x66FFFFFF)),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xEE141020), Color(0x44141020)],
                ),
              ),
              child: Row(
                children: [
                  _IconDisc(icon: icon, size: 68),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFFFFF1B0),
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Color(0xFFEDE7FA),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResourceChip extends StatelessWidget {
  const _ResourceChip({required this.icon, required this.value});

  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 4, right: 10),
      decoration: BoxDecoration(
        color: const Color(0xB0000000),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, width: 30, height: 30),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageButton extends StatelessWidget {
  const _ImageButton({required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(icon, width: 44, height: 44),
    );
  }
}

class _IconDisc extends StatelessWidget {
  const _IconDisc({required this.icon, this.size = 56});

  final String icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0x99A7C7FF), Color(0x88525BD9)],
        ),
      ),
      child: Center(
        child: Image.asset(icon, width: size * 0.72, height: size * 0.72),
      ),
    );
  }
}

class _ActivityToken extends StatelessWidget {
  const _ActivityToken({required this.icon, required this.value});

  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Color(0xEEFFFFFF), Color(0x99C98BFF), Color(0x88585DD8)],
            ),
          ),
          child: Center(child: Image.asset(icon, width: 74)),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              minHeight: 10,
              value: 0.2,
              backgroundColor: Color(0xFFC6C1D2),
              valueColor: AlwaysStoppedAnimation(Color(0xFFFFE063)),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            shadows: [Shadow(color: Colors.black, blurRadius: 3)],
          ),
        ),
      ],
    );
  }
}

class _DailyTaskTile extends StatelessWidget {
  const _DailyTaskTile({
    required this.task,
    this.onClaim,
    this.onGo,
  });

  final _DailyTask task;
  final VoidCallback? onClaim;
  final VoidCallback? onGo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          const _ActivityScoreBubble(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF74799B),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB5B5C0),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: task.ratio,
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDD55),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                      child: Center(
                        child: Text(
                          task.progress,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _SmallReward(icon: task.icon, amount: task.amount),
          const SizedBox(width: 12),
          _RedActionButton(
            label: task.claimed ? '已领取' : (task.claimable ? '领取' : '前往'),
            disabled: task.claimed,
            onTap: task.claimable ? onClaim : onGo,
          ),
        ],
      ),
    );
  }
}

class _ActivityScoreBubble extends StatelessWidget {
  const _ActivityScoreBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF7EA7), Color(0xFFFF2A39)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '10',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.0,
                shadows: [Shadow(color: Color(0xAA8B1D1D), blurRadius: 3)],
              ),
            ),
            Text(
              '活跃度',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallReward extends StatelessWidget {
  const _SmallReward({required this.icon, required this.amount, this.size = 64});

  final String icon;
  final String amount;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconSize = size * 0.67;
    return SizedBox(
      width: size,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: size - 6,
            height: size - 6,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFA828), Color(0xFF7558D6)],
              ),
            ),
            child: Center(child: Image.asset(icon, width: iconSize, height: iconSize)),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              shadows: [Shadow(color: Colors.black, blurRadius: 3)],
            ),
          ),
        ],
      ),
    );
  }
}

class _RedActionButton extends StatelessWidget {
  const _RedActionButton({required this.label, this.disabled = false, this.onTap});

  final String label;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 40,
      decoration: BoxDecoration(
        color: disabled ? const Color(0xFF576078) : const Color(0xFFE24B3F),
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(color: Color(0x55000000), offset: Offset(0, 2)),
        ],
      ),
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyClaimBar extends StatelessWidget {
  const _DailyClaimBar({this.onClaimAll});

  final VoidCallback? onClaimAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: const BoxDecoration(
        color: Color(0xFFE0DDE3),
        border: Border(top: BorderSide(color: Colors.white)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: Color(0xFF55C14E),
            size: 24,
          ),
          const SizedBox(width: 4),
          const Text(
            '11时44分',
            style: TextStyle(
              color: Color(0xFF49A93F),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onClaimAll,
            child: Container(
              width: 136,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE34B3F),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Color(0x55000000), offset: Offset(0, 2)),
                ],
              ),
              child: const Center(
                child: Text(
                  '一键领取',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _SignInSideRail extends StatelessWidget {
  const _SignInSideRail();

  static const _items = [
    (_iconRank, '特权'),
    (_iconToken, '活跃'),
    (_iconChest, '每日签到'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      decoration: const BoxDecoration(
        color: Color(0xB566417D),
        border: Border(right: BorderSide(color: Color(0xFFFF5578), width: 6)),
      ),
      child: Column(
        children: [
          const Spacer(),
          ...List.generate(_items.length, (index) {
            final item = _items[index];
            final active = index == 2;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              color: active ? const Color(0x667B3AAF) : Colors.transparent,
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(item.$1, width: 48, height: 48),
                      if (index == 2)
                        const Positioned(
                          right: -2,
                          top: -2,
                          child: _NoticeDot(),
                        ),
                    ],
                  ),
                  Text(
                    item.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Spacer(),
          _ImageButton(icon: _iconBack, onTap: () => _popOrHome(context)),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

class _NoticeDot extends StatelessWidget {
  const _NoticeDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: const BoxDecoration(
        color: Color(0xFFE73737),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _Milestone {
  const _Milestone(this.requiredDays, this.icon, this.amount, this.label);
  final int requiredDays;
  final String icon;
  final String amount;
  final String label;
}

class _SignInInfoBar extends StatelessWidget {
  const _SignInInfoBar({
    required this.totalDays,
    required this.consecutiveDays,
    required this.signedInToday,
    required this.onSignIn,
  });

  final int totalDays;
  final int consecutiveDays;
  final bool signedInToday;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x88000000),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x44FFFFFF)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '累计签到 $totalDays 天',
                style: const TextStyle(
                  color: Color(0xFFFFF0A6),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '连续签到 $consecutiveDays 天',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: signedInToday ? null : onSignIn,
            child: Container(
              width: 110,
              height: 42,
              decoration: BoxDecoration(
                color: signedInToday
                    ? const Color(0xFF576078)
                    : const Color(0xFFE24B3F),
                borderRadius: BorderRadius.circular(8),
                boxShadow: signedInToday
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x55000000),
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  signedInToday ? '已签到' : '立即签到',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInMilestones extends StatelessWidget {
  const _SignInMilestones({
    required this.milestones,
    required this.consecutiveDays,
    required this.onClaim,
  });

  final List<_Milestone> milestones;
  final int consecutiveDays;
  final ValueChanged<_Milestone> onClaim;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: milestones.map((m) {
        final reached = consecutiveDays >= m.requiredDays;
        return Expanded(
          child: GestureDetector(
            onTap: () => onClaim(m),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(_iconChest, width: 46, height: 46),
                      if (reached)
                        const Positioned(
                          right: 0,
                          top: 0,
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xFF55B9FF),
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    m.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: reached ? const Color(0xFFFFF0A6) : Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(m.icon, width: 18, height: 18),
                      const SizedBox(width: 2),
                      Text(
                        m.amount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({
    required this.reward,
    required this.claimed,
    this.claimable = false,
    this.onTap,
  });

  final _Reward reward;
  final bool claimed;
  final bool claimable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: claimed || !claimable ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: claimed
                ? [const Color(0xFF888888), const Color(0xFF666666)]
                : claimable
                    ? [const Color(0xFFFFBD4A), const Color(0xFFFF8E21)]
                    : [const Color(0xFFFFD69A), const Color(0xFFFFA34C)],
          ),
          border: Border.all(
            color: claimable && !claimed
                ? const Color(0xFFFFD283)
                : Colors.white,
            width: claimable && !claimed ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                _iconFramePurple,
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.35),
              ),
            ),
            Center(child: Image.asset(reward.icon, width: 44, height: 44)),
            Positioned(
              right: 3,
              bottom: 2,
              child: Text(
                reward.amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                ),
              ),
            ),
            if (claimed)
              const Positioned(
                left: 4,
                top: 4,
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF55B9FF),
                  size: 17,
                ),
              ),
            if (!claimed && reward.label.isNotEmpty)
              Positioned(
                left: 3,
                top: 2,
                child: Text(
                  reward.label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GiftPackTile extends StatefulWidget {
  const _GiftPackTile({required this.pack});

  final _GiftPack pack;

  @override
  State<_GiftPackTile> createState() => _GiftPackTileState();
}

class _GiftPackTileState extends State<_GiftPackTile> {
  int _purchased = 0;

  bool get _soldOut => _purchased >= widget.pack.limit;

  void _onExchange() {
    if (_soldOut) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('确认兑换',
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('消耗 ${widget.pack.costAmount} 元宝兑换「${widget.pack.title}」？'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.pack.rewards
                  .map((r) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _SmallReward(icon: r.icon, amount: r.amount),
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD64B3F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _purchased++);
              _showRewardDialog();
            },
            child: const Text('确认兑换'),
          ),
        ],
      ),
    );
  }

  void _showRewardDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('兑换成功',
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('恭喜获得以下奖励：'),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.pack.rewards
                  .map((r) => _SmallReward(icon: r.icon, amount: r.amount))
                  .toList(),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('领取'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pack = widget.pack;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC244),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                pack.title,
                style: const TextStyle(
                  color: Color(0xFF3D4560),
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 奖励展示区
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: pack.rewards
                .map((reward) => _SmallReward(
                      icon: reward.icon,
                      amount: reward.amount,
                      size: 58,
                    ))
                .toList(),
          ),
          const SizedBox(height: 14),
          // 分隔线
          Container(
            height: 1,
            color: const Color(0xFFD8D8E4),
          ),
          const SizedBox(height: 12),
          // 底部操作区
          Row(
            children: [
              Text(
                '限购 $_purchased/${pack.limit}',
                style: const TextStyle(
                  color: Color(0xFF8E92A8),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _soldOut ? null : _onExchange,
                child: Container(
                  width: 120,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _soldOut
                        ? const Color(0xFFB0B0B0)
                        : const Color(0xFFD64B3F),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: _soldOut
                        ? null
                        : [
                            BoxShadow(
                              color: const Color(0x66D64B3F),
                              offset: const Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(pack.costIcon, width: 20, height: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${pack.costAmount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
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

class _TimePill extends StatelessWidget {
  const _TimePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xAA4F4B55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _WorldRewardBanner extends StatelessWidget {
  const _WorldRewardBanner({
    required this.icon,
    required this.count,
    required this.chapter,
    required this.stage,
    this.tall = false,
    this.onTap,
  });

  final String icon;
  final String count;
  final String chapter;
  final String stage;
  final bool tall;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: Offset(0, tall ? -20 : 0),
        child: Container(
        height: tall ? 244 : 220,
        padding: const EdgeInsets.fromLTRB(10, 18, 10, 12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xAA546AF2), Color(0xFFE7E7FF)],
          ),
          border: Border.all(color: const Color(0x996F7AFF), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0x885D6CFF), blurRadius: 18),
          ],
        ),
        child: Column(
          children: [
            _IconDisc(icon: icon, size: 68),
            const SizedBox(height: 6),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
            const Spacer(),
            Text(
              chapter,
              style: const TextStyle(
                color: Color(0xFF7277A5),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                stage,
                style: const TextStyle(
                  color: Color(0xFF696E93),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

void _popOrHome(BuildContext context) {
  final router = GoRouter.maybeOf(context);
  if (router != null && router.canPop()) {
    router.pop();
    return;
  }
  if (router != null) {
    router.go(RoutePaths.home);
    return;
  }
  Navigator.of(context).maybePop();
}
