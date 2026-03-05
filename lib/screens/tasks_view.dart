import 'package:flutter/material.dart';
import '../state/game_state.dart';
import '../widgets/game_background.dart';

class TaskItem {
  final String id;
  final String title;
  final String desc;
  final int target;
  int current;
  final int goldReward;
  final int expReward;
  bool isClaimed;

  TaskItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.target,
    this.current = 0,
    required this.goldReward,
    required this.expReward,
    this.isClaimed = false,
  });

  double get progress => (current / target).clamp(0.0, 1.0);
  bool get canClaim => current >= target && !isClaimed;
}

class TasksView extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onSave;

  const TasksView({super.key, required this.gameState, required this.onSave});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final List<TaskItem> _tasks = [
    TaskItem(
      id: 't1',
      title: '初露の鋒芒',
      desc: '探険で 1 回の戦闘を完了する',
      target: 1,
      current: 1,
      goldReward: 500,
      expReward: 1000,
    ),
    TaskItem(
      id: 't2',
      title: '招兵買馬',
      desc: '英雄召喚を 3 回行う',
      target: 3,
      current: 1,
      goldReward: 1000,
      expReward: 2000,
    ),
    TaskItem(
      id: 't3',
      title: '勤学苦練',
      desc: '英雄のレベルを 5 回上昇させる',
      target: 5,
      current: 3,
      goldReward: 800,
      expReward: 1500,
    ),
  ];

  void _claimTask(TaskItem task) {
    setState(() {
      task.isClaimed = true;
      widget.gameState.addGold(task.goldReward);
      widget.gameState.addExp(task.expReward);
    });
    widget.gameState.save();
    widget.onSave();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.amber.shade800,
        content: Text(
          '受取完了！ゴールド x${task.goldReward}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('tasks'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('tasks'),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            '任務実績',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: _tasks.length,
          itemBuilder: (context, index) => _buildTaskCard(_tasks[index]),
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskItem task) {
    final bool canClaim = task.canClaim;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: task.isClaimed ? 0.6 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff1c1c24),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: canClaim ? Colors.amber.withOpacity(0.5) : Colors.white10,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            _buildRewardBadge(task),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.desc,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _buildProgressBar(task),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildActionButton(task),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardBadge(TaskItem task) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.card_giftcard, color: Colors.amber),
    );
  }

  Widget _buildProgressBar(TaskItem task) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: task.progress,
          backgroundColor: Colors.white10,
          valueColor: AlwaysStoppedAnimation<Color>(
            task.canClaim ? Colors.amber : Colors.blue,
          ),
          borderRadius: BorderRadius.circular(10),
          minHeight: 6,
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${task.current}/${task.target}',
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(TaskItem task) {
    if (task.isClaimed)
      return const Icon(Icons.check_circle, color: Colors.green);
    return ElevatedButton(
      onPressed: task.canClaim ? () => _claimTask(task) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        disabledBackgroundColor: Colors.white10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(
        task.canClaim ? '受取' : '進行中',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
