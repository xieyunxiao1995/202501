import 'package:flutter/material.dart';

/// 每日任务页面
class DailyTasksScreen extends StatefulWidget {
  const DailyTasksScreen({super.key});

  @override
  State<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> {
  // 模拟每日任务数据
  final List<DailyTask> _dailyTasks = [
    DailyTask(
      id: 'daily_1',
      title: '初次出击',
      description: '完成3场游戏',
      icon: '🎮',
      current: 1,
      target: 3,
      reward: 50,
      rewardType: '星尘',
      isCompleted: false,
      color: const Color(0xFF00FF88),
    ),
    DailyTask(
      id: 'daily_2',
      title: '合并大师',
      description: '进行10次合并操作',
      icon: '🔗',
      current: 7,
      target: 10,
      reward: 30,
      rewardType: '星尘',
      isCompleted: false,
      color: const Color(0xFF00C3FF),
    ),
    DailyTask(
      id: 'daily_3',
      title: '星辰猎手',
      description: '消灭50个敌人',
      icon: '⚔️',
      current: 50,
      target: 50,
      reward: 80,
      rewardType: '星尘',
      isCompleted: true,
      color: const Color(0xFFFF003C),
    ),
    DailyTask(
      id: 'daily_4',
      title: '连击挑战',
      description: '单局达到15连击',
      icon: '🔥',
      current: 0,
      target: 15,
      reward: 60,
      rewardType: '星尘',
      isCompleted: false,
      color: const Color(0xFFFFEA00),
    ),
    DailyTask(
      id: 'daily_5',
      title: '关卡推进',
      description: '通过任意2关',
      icon: '🌟',
      current: 1,
      target: 2,
      reward: 100,
      rewardType: '星尘',
      isCompleted: false,
      color: const Color(0xFFB700FF),
    ),
    DailyTask(
      id: 'daily_6',
      title: '完美防守',
      description: '一局游戏中基地不受损',
      icon: '🛡️',
      current: 0,
      target: 1,
      reward: 70,
      rewardType: '星尘',
      isCompleted: false,
      color: const Color(0xFFFF00AA),
    ),
  ];

  // 每周任务
  final List<DailyTask> _weeklyTasks = [
    DailyTask(
      id: 'weekly_1',
      title: '每周目标',
      description: '累计通过10关',
      icon: '🗺️',
      current: 4,
      target: 10,
      reward: 200,
      rewardType: '星尘',
      isCompleted: false,
      color: const Color(0xFFFF6644),
    ),
    DailyTask(
      id: 'weekly_2',
      title: '合并狂人',
      description: '累计合并100次',
      icon: '⚙️',
      current: 67,
      target: 100,
      reward: 150,
      rewardType: '星尘',
      isCompleted: false,
      color: const Color(0xFF44DDFF),
    ),
    DailyTask(
      id: 'weekly_3',
      title: '终极挑战',
      description: '获得50000分以上',
      icon: '👑',
      current: 32000,
      target: 50000,
      reward: 300,
      rewardType: '星尘',
      isCompleted: false,
      color: const Color(0xFFFFDD44),
    ),
  ];

  int get _claimedRewards =>
      _dailyTasks.where((t) => t.isCompleted && t.isClaimed).length +
      _weeklyTasks.where((t) => t.isCompleted && t.isClaimed).length;

  int get _totalPossibleRewards => _dailyTasks.length + _weeklyTasks.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('每日任务'),
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
        actions: [
          // 刷新倒计时
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 18,
                  color: Color(0xFF8899AA),
                ),
                const SizedBox(width: 4),
                const Text(
                  '重置:',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8899AA)),
                ),
                const SizedBox(width: 2),
                Text(
                  '08:32:15',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00F0FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 总进度
          _buildTotalProgress(),
          const SizedBox(height: 16),
          // 任务列表
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // 每日任务
                _buildSectionHeader('每日任务', '📋', const Color(0xFF00F0FF)),
                const SizedBox(height: 8),
                ..._dailyTasks.map((task) => _buildTaskCard(task)),
                const SizedBox(height: 20),
                // 每周任务
                _buildSectionHeader('每周任务', '📅', const Color(0xFFFFEA00)),
                const SizedBox(height: 8),
                ..._weeklyTasks.map((task) => _buildTaskCard(task)),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalProgress() {
    final progress =
        _claimedRewards / _totalPossibleRewards.clamp(1, _totalPossibleRewards);
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
                '🎯 任务进度',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '$_claimedRewards / $_totalPossibleRewards',
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
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFF1A2240),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF00F0FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String icon, Color color) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(DailyTask task) {
    final progress = task.current / task.target.clamp(1, task.target);
    final isCompleted = task.isCompleted;
    final isClaimed = task.isClaimed;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCompleted
            ? task.color.withOpacity(0.1)
            : const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted
              ? task.color.withOpacity(0.4)
              : const Color(0xFF1A2240),
          width: 1.5,
        ),
        boxShadow: isCompleted
            ? [BoxShadow(color: task.color.withOpacity(0.15), blurRadius: 10)]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部
          Row(
            children: [
              Text(task.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? Colors.white
                                : const Color(0xFFCCDDEE),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEA00).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('💰', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 2),
                              Text(
                                '+${task.reward}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFFFEA00),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8899AA),
                      ),
                    ),
                  ],
                ),
              ),
              // 状态
              if (isCompleted && isClaimed)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF00FF88),
                  size: 24,
                )
              else if (isCompleted && !isClaimed)
                ElevatedButton(
                  onPressed: () {
                    setState(() => task.isClaimed = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('已领取 ${task.reward} ${task.rewardType}'),
                        backgroundColor: const Color(0xFF00FF88),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF88),
                    foregroundColor: const Color(0xFF030408),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '领取',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // 进度条
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: const Color(0xFF1A2240),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? const Color(0xFF00FF88) : task.color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${task.current}/${task.target}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? const Color(0xFF00FF88) : task.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DailyTask {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int current;
  final int target;
  final int reward;
  final String rewardType;
  bool isCompleted;
  bool isClaimed;
  final Color color;

  DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.current,
    required this.target,
    required this.reward,
    required this.rewardType,
    required this.isCompleted,
    this.isClaimed = false,
    required this.color,
  });
}
