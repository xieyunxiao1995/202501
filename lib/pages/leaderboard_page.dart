import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class LeaderboardEntry {
  final int rank;
  final String playerName;
  final int score;
  final int beastsCollected;
  final int battleWins;

  LeaderboardEntry({
    required this.rank,
    required this.playerName,
    required this.score,
    required this.beastsCollected,
    required this.battleWins,
  });
}

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.height < 600;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [_buildSliverAppBar(isSmallScreen)];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildLeaderboard('总战力', isSmallScreen),
            _buildLeaderboard('异兽数', isSmallScreen),
            _buildLeaderboard('战斗胜', isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(bool isSmallScreen) {
    return SliverAppBar(
      expandedHeight: isSmallScreen ? 100 : 120,
      pinned: true,
      backgroundColor: AppColors.bg,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '排行榜',
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmallScreen ? 16 : 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.leaderboard_outlined,
                  size: isSmallScreen ? 120 : 150,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bg,
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSub,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
            labelStyle: TextStyle(
              fontSize: isSmallScreen ? 14 : 15,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: isSmallScreen ? 14 : 15,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: '总战力'),
              Tab(text: '异兽数'),
              Tab(text: '战斗胜'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboard(String type, bool isSmallScreen) {
    final entries = _getMockLeaderboard(type);

    return CustomScrollView(
      key: PageStorageKey<String>(type),
      slivers: [
        SliverToBoxAdapter(child: _buildTopThree(entries, isSmallScreen)),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, isSmallScreen ? 60 : 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              // index 0 在这里对应 entries[3]，因为前三个在 _buildTopThree 中
              if (index + 3 >= entries.length) return null;
              return _buildLeaderboardItem(
                entries[index + 3],
                type,
                isSmallScreen,
              );
            }, childCount: entries.length - 3),
          ),
        ),
      ],
    );
  }

  Widget _buildTopThree(List<LeaderboardEntry> entries, bool isSmallScreen) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final top3 = entries.take(3).toList();

    return Container(
      padding: EdgeInsets.fromLTRB(
        isSmallScreen ? 16 : 20,
        isSmallScreen ? 20 : 30,
        isSmallScreen ? 16 : 20,
        isSmallScreen ? 30 : 40,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary.withValues(alpha: 0.05), AppColors.bg],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (top3.length > 1) ...[
            _buildPodium(top3[1], 2, isSmallScreen),
            SizedBox(width: isSmallScreen ? 8 : 12),
          ],
          if (top3.isNotEmpty) _buildPodium(top3[0], 1, isSmallScreen),
          if (top3.length > 2) ...[
            SizedBox(width: isSmallScreen ? 8 : 12),
            _buildPodium(top3[2], 3, isSmallScreen),
          ],
        ],
      ),
    );
  }

  Widget _buildPodium(LeaderboardEntry entry, int rank, bool isSmallScreen) {
    final isFirst = rank == 1;
    final rankColor = rank == 1
        ? const Color(0xFFFFD700) // Gold
        : rank == 2
        ? const Color(0xFFC0C0C0) // Silver
        : const Color(0xFFCD7F32); // Bronze

    final avatarSize = isFirst
        ? (isSmallScreen ? 70.0 : 90.0)
        : (isSmallScreen ? 60.0 : 75.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 排名图标/数字
        Stack(
          alignment: Alignment.center,
          children: [
            // 光效背景
            if (isFirst)
              Container(
                width: avatarSize + (isSmallScreen ? 15 : 20),
                height: avatarSize + (isSmallScreen ? 15 : 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: rankColor.withValues(alpha: 0.2),
                      blurRadius: isSmallScreen ? 15 : 20,
                      spreadRadius: isSmallScreen ? 3 : 5,
                    ),
                  ],
                ),
              ),
            // 头像框
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: rankColor,
                  width: isSmallScreen ? 2 : 3,
                ),
                color: AppColors.card,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  entry.playerName.substring(0, 1),
                  style: TextStyle(
                    color: rankColor,
                    fontSize: isFirst
                        ? (isSmallScreen ? 28 : 36)
                        : (isSmallScreen ? 22 : 28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // 排名标识
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: rankColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'NO.$rank',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isSmallScreen ? 8 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Text(
          entry.playerName,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: isFirst
                ? (isSmallScreen ? 14 : 16)
                : (isSmallScreen ? 12 : 14),
            fontWeight: isFirst ? FontWeight.bold : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: rankColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${entry.score}',
            style: TextStyle(
              color: rankColor,
              fontSize: isFirst
                  ? (isSmallScreen ? 14 : 16)
                  : (isSmallScreen ? 12 : 14),
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(
    LeaderboardEntry entry,
    String type,
    bool isSmallScreen,
  ) {
    String unit = type == '总战力'
        ? '战力值'
        : type == '异兽数'
        ? '异兽数'
        : '胜场数';

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              child: Row(
                children: [
                  // 排名
                  Container(
                    width: isSmallScreen ? 32 : 36,
                    height: isSmallScreen ? 32 : 36,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.rank}',
                        style: TextStyle(
                          color: AppColors.textSub,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  // 玩家信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.playerName,
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.pets,
                              size: isSmallScreen ? 10 : 12,
                              color: AppColors.textSub,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${entry.beastsCollected}',
                              style: TextStyle(
                                color: AppColors.textSub,
                                fontSize: isSmallScreen ? 10 : 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.emoji_events,
                              size: isSmallScreen ? 10 : 12,
                              color: AppColors.textSub,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${entry.battleWins}',
                              style: TextStyle(
                                color: AppColors.textSub,
                                fontSize: isSmallScreen ? 10 : 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 分数
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${entry.score}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          color: AppColors.textSub.withValues(alpha: 0.5),
                          fontSize: isSmallScreen ? 9 : 10,
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

  List<LeaderboardEntry> _getMockLeaderboard(String type) {
    final List<String> names = [
      '山海尊者',
      '洪荒霸主',
      '异兽之王',
      '天选之子',
      '荒野游侠',
      '御兽师',
      '山神之子',
      '海神之徒',
      '风行者',
      '火神信徒',
      '玄武宗主',
      '青龙战神',
      '朱雀仙子',
      '白虎统领',
      '混沌使者',
    ];

    return List.generate(names.length, (index) {
      int scoreBase = type == '总战力'
          ? 10000
          : type == '异兽数'
          ? 10
          : 20;
      int multiplier = names.length - index;

      return LeaderboardEntry(
        rank: index + 1,
        playerName: names[index],
        score: scoreBase * multiplier + (index * 123),
        beastsCollected: (names.length - index) * 5 + (index % 3),
        battleWins: (names.length - index) * 8 + (index % 5),
      );
    });
  }
}
