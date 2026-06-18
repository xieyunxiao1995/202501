import 'package:flutter/material.dart';

/// 科技研究数据
class _TechData {
  _TechData({required this.name, required this.icon, required this.level, required this.maxLevel, required this.bonusPerLevel, required this.baseSeconds});

  final String name;
  final String icon;
  int level;
  final int maxLevel;
  final String bonusPerLevel; // 每级加成描述模板，如 '武将攻击 +{level}%'
  final int baseSeconds; // 每级基础研究时间（秒）

  String get bonus => bonusPerLevel.replaceAll('{level}', '${level * 5}');
  int get nextLevelSeconds => baseSeconds + (level * 60); // 逐级递增1分钟

  bool get isMaxed => level >= maxLevel;
}

/// 研究队列任务
class _ResearchTask {
  _ResearchTask({required this.techIndex, required this.techName, required this.totalSeconds, this.progress = 0.0, int? remainingSeconds})
    : remainingSeconds = remainingSeconds ?? totalSeconds;

  final int techIndex;
  final String techName;
  final int totalSeconds;
  double progress;
  int remainingSeconds;

  String get remainingText {
    final h = remainingSeconds ~/ 3600;
    final m = (remainingSeconds % 3600) ~/ 60;
    final s = remainingSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get isComplete => progress >= 1.0;
}

/// 学堂页面
///
/// 研究战法，提升战术等级。
class AcademyPage extends StatefulWidget {
  const AcademyPage({super.key});

  @override
  State<AcademyPage> createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage> {
  static const _maxQueues = 2;

  final List<_TechData> _techs = [
    _TechData(name: '军事理论', icon: '⚔️', level: 5, maxLevel: 10, baseSeconds: 1800, bonusPerLevel: '武将攻击 +{level}%'),
    _TechData(name: '阵法心得', icon: '🛡️', level: 3, maxLevel: 10, baseSeconds: 1500, bonusPerLevel: '武将防御 +{level}%'),
    _TechData(name: '兵法谋略', icon: '📖', level: 2, maxLevel: 10, baseSeconds: 2100, bonusPerLevel: '武将谋略 +{level}%'),
    _TechData(name: '后勤补给', icon: '🍞', level: 1, maxLevel: 10, baseSeconds: 1200, bonusPerLevel: '兵力上限 +{level}%'),
    _TechData(name: '攻城器械', icon: '🏗️', level: 0, maxLevel: 10, baseSeconds: 2400, bonusPerLevel: '攻城伤害 +{level}%'),
  ];

  final List<_ResearchTask> _queues = [];

  @override
  void initState() {
    super.initState();
    // 初始有 2 条正在研究的队列
    _queues.add(_ResearchTask(techIndex: 0, techName: '军事理论', totalSeconds: 2100, progress: 0.6, remainingSeconds: 840));
    _queues.add(_ResearchTask(techIndex: 1, techName: '阵法心得', totalSeconds: 1680, progress: 0.3, remainingSeconds: 1176));
    _startTick();
  }

  void _startTick() {
    Future.doWhile(() async {
      if (!mounted) return false;
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        for (final q in _queues) {
          if (!q.isComplete) {
            q.progress += 1.0 / q.totalSeconds;
            q.remainingSeconds = ((1.0 - q.progress) * q.totalSeconds).round();
            if (q.progress >= 1.0) {
              q.progress = 1.0;
              q.remainingSeconds = 0;
              _completeResearch(q);
            }
          }
        }
      });
      return _queues.any((q) => !q.isComplete);
    });
  }

  void _completeResearch(_ResearchTask task) {
    final tech = _techs[task.techIndex];
    tech.level++;
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('${task.techName} 研究完成！已升至 ${tech.level} 级'),
          backgroundColor: const Color(0xFF4CAF50),
          duration: const Duration(seconds: 2),
        ));
    }
  }

  void _startResearch(int techIndex) {
    final tech = _techs[techIndex];
    if (tech.isMaxed) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('已达到最高等级'), duration: Duration(seconds: 1)));
      return;
    }
    if (_queues.length >= _maxQueues) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('研究队列已满'), duration: Duration(seconds: 1)));
      return;
    }
    setState(() {
      _queues.add(_ResearchTask(
        techIndex: techIndex,
        techName: tech.name,
        totalSeconds: tech.nextLevelSeconds,
      ));
    });
    _startTick();
  }

  void _speedUp(int index) {
    final task = _queues[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('加速研究', style: TextStyle(color: Color(0xFFE8D5A3))),
        content: Text('花费 30 元宝立即完成 ${task.techName} 的研究？', style: const TextStyle(color: Color(0x998B7E6A))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A84B), foregroundColor: const Color(0xFF1A1111)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() { task.progress = 1.0; task.remainingSeconds = 0; });
              _completeResearch(task);
            },
            child: const Text('确认加速'),
          ),
        ],
      ),
    );
  }

  void _removeQueue(int index) {
    setState(() => _queues.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('学堂'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/city/xuetang.png'), fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, top: 0, bottom: 0,
            child: SafeArea(
              top: false,
              child: _AcademyPanel(
                techs: _techs,
                queues: _queues,
                maxQueues: _maxQueues,
                onStartResearch: _startResearch,
                onSpeedUp: _speedUp,
                onRemoveQueue: _removeQueue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 学堂面板
class _AcademyPanel extends StatelessWidget {
  const _AcademyPanel({
    required this.techs,
    required this.queues,
    required this.maxQueues,
    required this.onStartResearch,
    required this.onSpeedUp,
    required this.onRemoveQueue,
  });

  final List<_TechData> techs;
  final List<_ResearchTask> queues;
  final int maxQueues;
  final ValueChanged<int> onStartResearch;
  final ValueChanged<int> onSpeedUp;
  final ValueChanged<int> onRemoveQueue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC1A1111), Color(0xF21A1111)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: const Border(top: BorderSide(color: Color(0x40D4A84B), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PanelTitle(),
            const SizedBox(height: 14),
            // 科技列表
            ...techs.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildResearchItem(e.key, e.value),
            )),
            const SizedBox(height: 6),
            // 研究队列
            _QueueBar(queueCount: queues.length, maxQueues: maxQueues, queues: queues, onSpeedUp: onSpeedUp, onRemoveQueue: onRemoveQueue),
          ],
        ),
      ),
    );
  }

  Widget _buildResearchItem(int index, _TechData tech) {
    // 检查该科技是否有正在研究的队列
    final activeQueue = queues.cast<_ResearchTask?>().firstWhere(
      (q) => q != null && q.techIndex == index && !q.isComplete,
      orElse: () => null,
    );

    return GestureDetector(
      onTap: tech.isMaxed || activeQueue != null ? null : () => onStartResearch(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: activeQueue != null ? const Color(0x10D4A84B) : const Color(0x08FFFFFF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: activeQueue != null ? const Color(0x18D4A84B) : const Color(0x10FFFFFF)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(color: const Color(0x20D4A84B), borderRadius: BorderRadius.circular(6)),
                  child: Center(child: Text(tech.icon, style: const TextStyle(fontSize: 16))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tech.name, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(tech.bonus, style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tech.isMaxed ? const Color(0x204CAF50) : const Color(0x30D4A84B),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: tech.isMaxed ? const Color(0x404CAF50) : const Color(0x40D4A84B)),
                  ),
                  child: Text(
                    tech.isMaxed ? 'MAX' : '${tech.level}/${tech.maxLevel}',
                    style: TextStyle(
                      color: tech.isMaxed ? const Color(0xFF4CAF50) : const Color(0xFFD4A84B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (activeQueue != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.timer, size: 13, color: Color(0x998B7E6A)),
                  const SizedBox(width: 4),
                  Text(activeQueue.remainingText, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: activeQueue.progress,
                        minHeight: 4,
                        backgroundColor: const Color(0x33FFFFFF),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4A84B)),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (!tech.isMaxed) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.timer, size: 13, color: Color(0x668B7E6A)),
                  const SizedBox(width: 4),
                  Text(
                    _formatSeconds(tech.nextLevelSeconds),
                    style: const TextStyle(color: Color(0x668B7E6A), fontSize: 13),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => onStartResearch(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: const Text('研究', style: TextStyle(color: Color(0xFF1A1111), fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _formatSeconds(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    if (h > 0) return '${h}h${m}m';
    return '${m}m${s}s';
  }
}

/// 面板标题
class _PanelTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _goldLine(width: 40),
        const SizedBox(width: 12),
        const Text('学堂', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        _goldLine(width: 40),
      ],
    );
  }

  Widget _goldLine({required double width}) {
    return Container(
      width: width, height: 1.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)]),
      ),
    );
  }
}

/// 研究队列栏
class _QueueBar extends StatelessWidget {
  const _QueueBar({required this.queueCount, required this.maxQueues, required this.queues, required this.onSpeedUp, required this.onRemoveQueue});

  final int queueCount;
  final int maxQueues;
  final List<_ResearchTask> queues;
  final ValueChanged<int> onSpeedUp;
  final ValueChanged<int> onRemoveQueue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('研究队列: ', style: TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
        Text('$queueCount/$maxQueues', style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14, fontWeight: FontWeight.bold)),
        const Spacer(),
        // 队列缩影
        ...queues.asMap().entries.map((e) {
          final task = e.value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: task.isComplete ? () => onRemoveQueue(e.key) : () => onSpeedUp(e.key),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: task.isComplete ? const Color(0x204CAF50) : const Color(0x20D4A84B),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: task.isComplete ? const Color(0x404CAF50) : const Color(0x40D4A84B)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.techName.substring(0, 2),
                      style: TextStyle(color: task.isComplete ? const Color(0xFF4CAF50) : const Color(0xFFD4A84B), fontSize: 10),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      task.isComplete ? Icons.check_circle : Icons.play_arrow,
                      size: 12,
                      color: task.isComplete ? const Color(0xFF4CAF50) : const Color(0xFFD4A84B),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (queueCount < maxQueues)
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('请点击上方科技开始研究'), duration: Duration(seconds: 1)));
            },
            child: Container(
              width: 28, height: 28,
              decoration: BoxDecoration(border: Border.all(color: const Color(0x40D4A84B)), borderRadius: BorderRadius.circular(14)),
              child: const Center(child: Icon(Icons.add, size: 16, color: Color(0xCCD4A84B))),
            ),
          ),
      ],
    );
  }
}
