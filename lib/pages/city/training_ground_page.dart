import 'package:flutter/material.dart';

/// 训练队列数据
class _TrainTask {
  _TrainTask({
    required this.troopLabel,
    required this.troopIcon,
    required this.count,
    required this.totalSeconds,
    this.progress = 0.0,
    int? remainingSeconds,
  }) : remainingSeconds = remainingSeconds ?? totalSeconds;

  final String troopLabel;
  final String troopIcon;
  final int count;
  final int totalSeconds; // 总训练时间（秒）
  double progress; // 0.0 ~ 1.0
  int remainingSeconds; // 剩余秒数

  String get remainingText {
    final h = remainingSeconds ~/ 3600;
    final m = (remainingSeconds % 3600) ~/ 60;
    final s = remainingSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get isComplete => progress >= 1.0;
}

/// 校场页面
///
/// 训练士兵、提升兵种等级。
class TrainingGroundPage extends StatefulWidget {
  const TrainingGroundPage({super.key});

  @override
  State<TrainingGroundPage> createState() => _TrainingGroundPageState();
}

class _TrainingGroundPageState extends State<TrainingGroundPage> {
  static const _troops = [
    {'icon': '🗡️', 'label': '步兵', 'timePer1000': 300},  // 5分钟/1000
    {'icon': '🐴', 'label': '骑兵', 'timePer1000': 420},   // 7分钟/1000
    {'icon': '🏹', 'label': '弓兵', 'timePer1000': 360},   // 6分钟/1000
    {'icon': '🔱', 'label': '枪兵', 'timePer1000': 330},   // 5.5分钟/1000
  ];

  int _selectedTroopIndex = 0;
  int _trainLevel = 10;
  final List<_TrainTask> _queues = [];

  static const _maxQueues = 3;
  static const _batchCount = 5000; // 每次训练数量

  String get _selectedTroopIcon => _troops[_selectedTroopIndex]['icon'] as String;
  String get _selectedTroopLabel => _troops[_selectedTroopIndex]['label'] as String;
  int get _selectedTroopTimePer1000 => _troops[_selectedTroopIndex]['timePer1000'] as int;

  double get _speedBonus => 1.0 - (_trainLevel * 0.02); // 每级2%加速
  int get _batchBonus => (_trainLevel * 200); // 每级多200

  int get _effectiveCount => _batchCount + _batchBonus;
  int get _effectiveSeconds => (_selectedTroopTimePer1000 * _effectiveCount / 1000 * _speedBonus).round();

  @override
  void initState() {
    super.initState();
    // 初始有一条正在训练的队列
    _queues.add(_TrainTask(
      troopLabel: '步兵',
      troopIcon: '🗡️',
      count: 5000,
      totalSeconds: 6000,
      progress: 0.4,
      remainingSeconds: 3600,
    ));
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
              _showCompleteSnack(q);
            }
          }
        }
      });
      return _queues.any((q) => !q.isComplete);
    });
  }

  void _showCompleteSnack(_TrainTask task) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${task.troopLabel} x${task.count} 训练完成！'),
          backgroundColor: const Color(0xFF4CAF50),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _addQueue() {
    if (_queues.length >= _maxQueues) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('训练队列已满，最多 $_maxQueues 条'), duration: Duration(seconds: 1)),
        );
      return;
    }
    setState(() {
      _queues.add(_TrainTask(
        troopLabel: _selectedTroopLabel,
        troopIcon: _selectedTroopIcon,
        count: _effectiveCount,
        totalSeconds: _effectiveSeconds,
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
        title: const Text('加速训练', style: TextStyle(color: Color(0xFFE8D5A3))),
        content: Text(
          '花费 20 元宝立即完成 ${task.troopLabel} 的训练？',
          style: const TextStyle(color: Color(0x998B7E6A)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A84B),
              foregroundColor: const Color(0xFF1A1111),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                task.progress = 1.0;
                task.remainingSeconds = 0;
              });
              _showCompleteSnack(task);
            },
            child: const Text('确认加速'),
          ),
        ],
      ),
    );
  }

  void _removeQueue(int index) {
    setState(() {
      _queues.removeAt(index);
    });
  }

  void _showRules() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFFD4A84B), size: 22),
            SizedBox(width: 8),
            Text('校场规则', style: TextStyle(color: Color(0xFFE8D5A3))),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RuleItem(icon: '🗡️', text: '选择兵种后创建训练队列，自动计时训练'),
            SizedBox(height: 8),
            _RuleItem(icon: '⏱️', text: '不同兵种训练时间不同，骑兵>弓兵>枪兵>步兵'),
            SizedBox(height: 8),
            _RuleItem(icon: '📊', text: '提升校场等级可缩短训练时间并增加单次训练数量'),
            SizedBox(height: 8),
            _RuleItem(icon: '⚡', text: '使用元宝可立即完成训练'),
            SizedBox(height: 8),
            _RuleItem(icon: '📋', text: '最多同时训练 3 条队列'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('知道了', style: TextStyle(color: Color(0xFFD4A84B))),
          ),
        ],
      ),
    );
  }

  void _upgradeLevel() {
    if (_trainLevel >= 30) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('已达到最高等级'), duration: Duration(seconds: 1)));
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('升级校场', style: TextStyle(color: Color(0xFFE8D5A3))),
        content: Text(
          '消耗 50000 金币升级到 ${_trainLevel + 1} 级？\n训练速度: ${(_trainLevel * 2)}% → ${((_trainLevel + 1) * 2)}%\n单次数量: ${_batchCount + _batchBonus} → ${_batchCount + (_trainLevel + 1) * 200}',
          style: const TextStyle(color: Color(0x998B7E6A), height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _trainLevel++);
            },
            child: const Text('升级'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('校场'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/city/jiaochang.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部信息面板
          Positioned(left: 0, right: 0, bottom: 0, child: _TrainingPanel(
            selectedTroopIndex: _selectedTroopIndex,
            trainLevel: _trainLevel,
            speedBonus: _speedBonus,
            batchBonus: _batchBonus,
            queues: _queues,
            maxQueues: _maxQueues,
            selectedTroopLabel: _selectedTroopLabel,
            onTroopChanged: (i) => setState(() => _selectedTroopIndex = i),
            onAddQueue: _addQueue,
            onSpeedUp: _speedUp,
            onRemoveQueue: _removeQueue,
            onShowRules: _showRules,
            onUpgrade: _upgradeLevel,
          )),
        ],
      ),
    );
  }
}

/// 校场训练面板
class _TrainingPanel extends StatelessWidget {
  const _TrainingPanel({
    required this.selectedTroopIndex,
    required this.trainLevel,
    required this.speedBonus,
    required this.batchBonus,
    required this.queues,
    required this.maxQueues,
    required this.selectedTroopLabel,
    required this.onTroopChanged,
    required this.onAddQueue,
    required this.onSpeedUp,
    required this.onRemoveQueue,
    required this.onShowRules,
    required this.onUpgrade,
  });

  final int selectedTroopIndex;
  final int trainLevel;
  final double speedBonus;
  final int batchBonus;
  final List<_TrainTask> queues;
  final int maxQueues;
  final String selectedTroopLabel;
  final ValueChanged<int> onTroopChanged;
  final VoidCallback onAddQueue;
  final ValueChanged<int> onSpeedUp;
  final ValueChanged<int> onRemoveQueue;
  final VoidCallback onShowRules;
  final VoidCallback onUpgrade;

  static const _batchCount = 5000;
  int get _effectiveCount => _batchCount + batchBonus;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---- 标题栏 + 规则说明 ----
          _PanelHeader(onShowRules: onShowRules),
          const SizedBox(height: 14),
          // ---- 兵种选择 ----
          _TroopSelector(selectedIndex: selectedTroopIndex, onChanged: onTroopChanged),
          const SizedBox(height: 14),
          // ---- 等级 & 加成 + 升级 ----
          _LevelAndBonus(level: trainLevel, speedBonus: speedBonus, onUpgrade: onUpgrade),
          const SizedBox(height: 14),
          // ---- 训练队列 ----
          if (queues.isNotEmpty) ...[
            ...queues.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _TrainingQueue(task: e.value, index: e.key, onSpeedUp: onSpeedUp, onRemove: onRemoveQueue),
            )),
            const SizedBox(height: 4),
          ],
          // ---- 新增队列 ----
          _AddQueuePrompt(
            selectedTroopLabel: selectedTroopLabel,
            count: _effectiveCount,
            isFull: queues.length >= maxQueues,
            onTap: onAddQueue,
          ),
        ],
      ),
    );
  }
}

/// 面板标题 + 规则说明按钮
class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.onShowRules});
  final VoidCallback onShowRules;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _goldLine(width: 30),
            const SizedBox(width: 10),
            const Text('校场', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            _goldLine(width: 30),
          ],
        ),
        GestureDetector(
          onTap: onShowRules,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x60D4A84B)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('规则说明', style: TextStyle(color: Color(0xCCD4A84B), fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _goldLine({required double width}) {
    return Container(
      width: width,
      height: 1.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)]),
      ),
    );
  }
}

/// 兵种选择器
class _TroopSelector extends StatelessWidget {
  const _TroopSelector({required this.selectedIndex, required this.onChanged});
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _troops = [
    {'icon': '🗡️', 'label': '步兵'},
    {'icon': '🐴', 'label': '骑兵'},
    {'icon': '🏹', 'label': '弓兵'},
    {'icon': '🔱', 'label': '枪兵'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_troops.length, (i) {
        return GestureDetector(
          onTap: () => onChanged(i),
          child: _TroopTab(
            icon: _troops[i]['icon'] as String,
            label: _troops[i]['label'] as String,
            isSelected: i == selectedIndex,
          ),
        );
      }),
    );
  }
}

class _TroopTab extends StatelessWidget {
  const _TroopTab({required this.icon, required this.label, required this.isSelected});
  final String icon;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0x30D4A84B) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? const Color(0x80D4A84B) : const Color(0x20FFFFFF)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(
            color: isSelected ? const Color(0xFFE8D5A3) : const Color(0x668B7E6A),
            fontSize: 12,
          )),
        ],
      ),
    );
  }
}

/// 当前等级 & 加成
class _LevelAndBonus extends StatelessWidget {
  const _LevelAndBonus({required this.level, required this.speedBonus, required this.onUpgrade});
  final int level;
  final double speedBonus;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpgrade,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0x18D4A84B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x20D4A84B)),
        ),
        child: Row(
          children: [
            const Text('当前等级：', style: TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
            Text('${level}级', style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 13, fontWeight: FontWeight.bold)),
            const Spacer(),
            _bonusTag('训练速度 ${((1 - speedBonus) * 100).round()}%'),
            const SizedBox(width: 6),
            _bonusTag('单次 ${5000 + (level * 200)}'),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0x404CAF50)),
          ],
        ),
      ),
    );
  }

  Widget _bonusTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0x204CAF50),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0x404CAF50)),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 11)),
    );
  }
}

/// 训练队列
class _TrainingQueue extends StatelessWidget {
  const _TrainingQueue({required this.task, required this.index, required this.onSpeedUp, required this.onRemove});
  final _TrainTask task;
  final int index;
  final ValueChanged<int> onSpeedUp;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final isComplete = task.isComplete;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isComplete ? const Color(0x104CAF50) : const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isComplete ? const Color(0x304CAF50) : const Color(0x18D4A84B)),
      ),
      child: Row(
        children: [
          // 兵种图标
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isComplete ? const Color(0x204CAF50) : const Color(0x20D4A84B),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(child: Text(task.troopIcon, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 10),
          // 训练信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(isComplete ? '已完成' : '训练中', style: TextStyle(
                      color: isComplete ? const Color(0xFF4CAF50) : const Color(0xFF4CAF50),
                      fontSize: 11,
                    )),
                    const SizedBox(width: 6),
                    Text('${task.troopLabel} x${task.count}', style: const TextStyle(color: Color(0xCC8B7E6A), fontSize: 12)),
                    const Spacer(),
                    // 删除按钮
                    if (isComplete)
                      GestureDetector(
                        onTap: () => onRemove(index),
                        child: const Icon(Icons.close, size: 16, color: Color(0x558B7E6A)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 12, color: Color(0x998B7E6A)),
                    const SizedBox(width: 4),
                    Text(task.remainingText, style: TextStyle(
                      color: isComplete ? const Color(0xFF4CAF50) : const Color(0xFFE8D5A3),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: task.progress,
                          minHeight: 4,
                          backgroundColor: const Color(0x33FFFFFF),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isComplete ? const Color(0xFF4CAF50) : const Color(0xFFD4A84B),
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
          // 加速/完成按钮
          if (!isComplete)
            GestureDetector(
              onTap: () => onSpeedUp(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: const Text('加速', style: TextStyle(color: Color(0xFF1A1111), fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            )
          else
            GestureDetector(
              onTap: () => onRemove(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0x204CAF50),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0x404CAF50)),
                ),
                child: const Text('领取', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}

/// 新增训练队列
class _AddQueuePrompt extends StatelessWidget {
  const _AddQueuePrompt({required this.selectedTroopLabel, required this.count, required this.isFull, required this.onTap});
  final String selectedTroopLabel;
  final int count;
  final bool isFull;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isFull ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: isFull ? const Color(0x106A0F0F) : const Color(0x30D4A84B)),
          borderRadius: BorderRadius.circular(8),
          color: isFull ? const Color(0x08000000) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16, color: isFull ? const Color(0x306A0F0F) : const Color(0x998B7E6A)),
            const SizedBox(width: 4),
            Text(
              isFull ? '队列已满 (最多3条)' : '训练 $selectedTroopLabel x$count',
              style: TextStyle(color: isFull ? const Color(0x306A0F0F) : const Color(0x998B7E6A), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// 规则条目
class _RuleItem extends StatelessWidget {
  const _RuleItem({required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13, height: 1.5))),
      ],
    );
  }
}
