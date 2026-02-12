import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';

class TaskScreen extends StatefulWidget {
  final GameService? gameService;

  const TaskScreen({super.key, this.gameService});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data structure for tasks
  late List<Map<String, dynamic>> _dailyTasks;
  late List<Map<String, dynamic>> _mainTasks;
  late List<Map<String, dynamic>> _achievementTasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeTasks();
  }

  void _initializeTasks() {
    _dailyTasks = [
      {
        'id': 'd1',
        'title': '晨练',
        'desc': '完成一次任意难度的出征',
        'progress': 0,
        'maxProgress': 1,
        'reward': '50 墨',
        'rewardValue': 50,
        'status': 'pending', // pending, claimable, claimed
      },
      {
        'id': 'd2',
        'title': '狩猎',
        'desc': '击败 3 只异兽',
        'progress': 1,
        'maxProgress': 3,
        'reward': '80 墨',
        'rewardValue': 80,
        'status': 'pending',
      },
      {
        'id': 'd3',
        'title': '修整',
        'desc': '在商店购买任意 1 件物品',
        'progress': 0,
        'maxProgress': 1,
        'reward': '灵茶 x1',
        'rewardValue': 0, // Special item logic needed, or just ink for now
        'status': 'claimable', // Mock claimable for demo
      },
    ];

    _mainTasks = [
      {
        'id': 'm1',
        'title': '初入山海',
        'desc': '探索南山区域，寻找失落的记忆',
        'progress': 1,
        'maxProgress': 1,
        'reward': '200 墨',
        'rewardValue': 200,
        'status': 'claimable',
      },
      {
        'id': 'm2',
        'title': '异兽之谜',
        'desc': '收集 5 个不同的肢体部件',
        'progress': 2,
        'maxProgress': 5,
        'reward': '稀有肢体箱',
        'rewardValue': 0,
        'status': 'pending',
      },
      {
        'id': 'm3',
        'title': '古老契约',
        'desc': '击败首领级异兽“饕餮”',
        'progress': 0,
        'maxProgress': 1,
        'reward': '传说核心',
        'rewardValue': 0,
        'status': 'pending',
      },
    ];

    _achievementTasks = [
      {
        'id': 'a1',
        'title': '百万富翁',
        'desc': '累计获得 1000 墨',
        'progress': 350,
        'maxProgress': 1000,
        'reward': '称号：财主',
        'rewardValue': 0,
        'status': 'pending',
      },
      {
        'id': 'a2',
        'title': '身经百战',
        'desc': '累计击败 100 只异兽',
        'progress': 12,
        'maxProgress': 100,
        'reward': '称号：猎手',
        'rewardValue': 0,
        'status': 'pending',
      },
      {
        'id': 'a3',
        'title': '收藏家',
        'desc': '解锁图鉴中 50% 的条目',
        'progress': 5,
        'maxProgress': 50,
        'reward': '特殊边框',
        'rewardValue': 0,
        'status': 'pending',
      },
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _claimReward(Map<String, dynamic> task) {
    if (task['status'] != 'claimable') return;

    setState(() {
      task['status'] = 'claimed';
    });

    if (widget.gameService != null && task['rewardValue'] > 0) {
      if (task['reward'].toString().contains('墨')) {
        widget.gameService!.restoreInk(task['rewardValue']);
      }
      // Future: Handle item rewards
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已领取奖励: ${task['reward']}', style: GoogleFonts.notoSerifSc(color: AppColors.bgPaper)),
        backgroundColor: AppColors.inkBlack,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      body: Stack(
        children: [
          // Background texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.network(
                'https://www.transparenttextures.com/patterns/paper-fibers.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: AppColors.bgPaper),
              ),
            ),
          ),
          
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: AppColors.bgPaper.withOpacity(0.9),
                  title: Text(
                    '悬赏令', 
                    style: GoogleFonts.maShanZheng(
                      color: AppColors.inkBlack, 
                      fontSize: isSmallScreen ? 22 : 26,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  centerTitle: true,
                  floating: true,
                  pinned: true,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: AppColors.inkBlack),
                  bottom: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.inkRed,
                    unselectedLabelColor: AppColors.inkBlack.withOpacity(0.6),
                    indicatorColor: AppColors.inkRed,
                    indicatorWeight: 3,
                    labelStyle: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 16 : 20),
                    unselectedLabelStyle: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 14 : 18),
                    tabs: const [
                      Tab(text: '每日'),
                      Tab(text: '主线'),
                      Tab(text: '成就'),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(_dailyTasks, isSmallScreen),
                _buildTaskList(_mainTasks, isSmallScreen),
                _buildTaskList(_achievementTasks, isSmallScreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Map<String, dynamic>> tasks, bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(tasks[index], isSmallScreen);
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, bool isSmallScreen) {
    final status = task['status'] as String;
    final isClaimed = status == 'claimed';
    final isClaimable = status == 'claimable';
    final progress = task['progress'] as int;
    final maxProgress = task['maxProgress'] as int;
    final percent = (progress / maxProgress).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: isClaimed ? Colors.grey.withOpacity(0.1) : AppColors.bgPaper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isClaimable ? AppColors.inkRed : AppColors.inkBlack.withOpacity(0.2),
          width: isClaimable ? 2 : 1,
        ),
        boxShadow: [
          if (!isClaimed)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'],
                            style: GoogleFonts.maShanZheng(
                              fontSize: isSmallScreen ? 18 : 20, 
                              fontWeight: FontWeight.bold,
                              color: isClaimed ? Colors.grey : AppColors.inkBlack,
                              decoration: isClaimed ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            task['desc'],
                            style: GoogleFonts.notoSerifSc(
                              fontSize: isSmallScreen ? 12 : 14, 
                              color: isClaimed ? Colors.grey : Colors.black87
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isClaimable)
                      ElevatedButton(
                        onPressed: () => _claimReward(task),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.inkRed,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
                          minimumSize: isSmallScreen ? const Size(60, 32) : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text('领取', style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 14 : 16)),
                      )
                    else if (!isClaimed)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$progress / $maxProgress',
                          style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 10 : 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                
                // Reward & Progress Bar Row
                Row(
                  children: [
                    Icon(Icons.card_giftcard, size: isSmallScreen ? 14 : 16, color: isClaimed ? Colors.grey : AppColors.inkRed),
                    const SizedBox(width: 4),
                    Text(
                      task['reward'],
                      style: GoogleFonts.notoSerifSc(
                        fontSize: isSmallScreen ? 10 : 12, 
                        fontWeight: FontWeight.bold,
                        color: isClaimed ? Colors.grey : AppColors.inkRed
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isClaimed ? Colors.grey : (isClaimable ? AppColors.inkRed : AppColors.woodDark)
                          ),
                          minHeight: isSmallScreen ? 4 : 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Stamp for claimed
          if (isClaimed)
            Positioned(
              right: 16,
              bottom: 8,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5), width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '已完成',
                    style: GoogleFonts.maShanZheng(
                      fontSize: isSmallScreen ? 16 : 18, 
                      color: Colors.grey.withOpacity(0.5),
                      fontWeight: FontWeight.bold
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
