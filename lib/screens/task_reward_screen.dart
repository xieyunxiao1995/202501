import 'package:flutter/material.dart';
import '../widgets/background_wrapper.dart';
import '../utils/task_reward_manager.dart';

class TaskRewardScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Function(Map<String, int> rewards) onClaim;

  const TaskRewardScreen({
    super.key,
    required this.onClose,
    required this.onClaim,
  });

  @override
  State<TaskRewardScreen> createState() => _TaskRewardScreenState();
}

class _TaskRewardScreenState extends State<TaskRewardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    TaskRewardManager.loadTasks().then((_) {
      if (mounted) setState(() {});
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClaim(EventTask task) async {
    await TaskRewardManager.claimTask(task.id);
    widget.onClaim(task.rewards);
    if (mounted) setState(() {});
  }

  // Debug method
  void _debugComplete(EventTask task) async {
    await TaskRewardManager.debugCompleteTask(task.id);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg3.jpeg', // Using a different BG for variety
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Main Content
            Positioned.fill(
              child: Column(
                children: [
                  // Upper Area: Character & Title
                  Expanded(
                    flex: 6,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Character Image (Yellow Emperor Placeholder)
                        Positioned(
                          bottom: 0,
                          top: 40,
                          child: AnimatedBuilder(
                            animation: _floatAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _floatAnimation.value),
                                child: child,
                              );
                            },
                            child: Image.asset(
                              'assets/role/Role3.png', // Placeholder for Huang Di
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        // Title Text Overlay
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "送核心SSR+黄帝",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: isSmallScreen ? 28 : 36,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  shadows: const [
                                    Shadow(color: Colors.red, blurRadius: 10, offset: Offset(0, 2)),
                                    Shadow(color: Colors.black, blurRadius: 5),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "境界直升炼气后期40阶",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 16 : 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                                ),
                              ),
                              Text(
                                "超强伤害爆发，夺命追击斩杀",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: isSmallScreen ? 14 : 16,
                                  shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Rating Badge
                        Positioned(
                          right: isSmallScreen ? 20 : 40,
                          top: isSmallScreen ? 60 : 100,
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.amber,
                                child: Text("黄\n帝", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 4),
                              Column(
                                children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 20)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Area: Task Cards
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                        ),
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: TaskRewardManager.tasks.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final task = TaskRewardManager.tasks[index];
                          return _buildTaskCard(task, isSmallScreen);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Back Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                onPressed: widget.onClose,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black45,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(EventTask task, bool isSmallScreen) {
    bool isCompleted = task.status == TaskStatus.completed;
    bool isClaimed = task.status == TaskStatus.claimed;
    bool isOngoing = task.status == TaskStatus.ongoing;

    return Container(
      width: isSmallScreen ? 160 : 180,
      margin: const EdgeInsets.only(bottom: 20, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
            ),
            child: Text(
              task.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Icon Area
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Secret debug: triple tap to complete
                if (isOngoing) _debugComplete(task);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  task.iconPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Rewards Preview
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: task.rewards.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Using generic item icons based on key logic or just generic
                      const Icon(Icons.stars, size: 16, color: Colors.amber),
                      Text(
                        "${e.value}",
                        style: const TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: isClaimed
                    ? null
                    : (isCompleted ? () => _handleClaim(task) : widget.onClose),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isClaimed ? Colors.grey : (isCompleted ? Colors.amber : Colors.blueAccent),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: isClaimed ? Colors.grey[300] : Colors.blueAccent.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  isClaimed ? "已领取" : (isCompleted ? "领取" : "前往"),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
