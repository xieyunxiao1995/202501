import 'dart:math';

import 'package:flutter/material.dart';

/// 事件数据
class _Event {
  _Event({required this.title, required this.desc, required this.reward, required this.rewardIcon, required this.rewardValue, this.completed = false});

  final String title;
  final String desc;
  final String reward;
  final String rewardIcon;
  final String rewardValue;
  bool completed;
}

/// 议事厅页面
///
/// 接取日常/周常任务，领取奖励。
class CouncilHallPage extends StatefulWidget {
  const CouncilHallPage({super.key});

  @override
  State<CouncilHallPage> createState() => _CouncilHallPageState();
}

class _CouncilHallPageState extends State<CouncilHallPage> {
  final Random _rng = Random();
  int _dailyChances = 6;
  static const _maxDailyChances = 6;

  static const _allEvents = [
    {'title': '张弓事件', 'desc': '边境发现可疑流寇，需派兵巡查', 'reward': '声望', 'icon': '⭐', 'value': '+500'},
    {'title': '治渠水患', 'desc': '连日大雨，河道决堤，需组织民夫抢修', 'reward': '粮食', 'icon': '🌾', 'value': 'x50000'},
    {'title': '沼瘴贼才', 'desc': '沼泽中盘踞一伙盗贼，百姓苦不堪言', 'reward': '招贤令', 'icon': '📜', 'value': 'x3'},
    {'title': '整顿治安', 'desc': '城中近来盗窃频发，需加强巡逻', 'reward': '铜钱', 'icon': '🪙', 'value': 'x30000'},
    {'title': '军粮告急', 'desc': '前线战事吃紧，急需筹措粮草', 'reward': '粮食', 'icon': '🌾', 'value': 'x80000'},
    {'title': '演练新兵', 'desc': '新募义兵需操练，请派将领督导', 'reward': '经验书', 'icon': '📘', 'value': 'x10'},
    {'title': '修缮城墙', 'desc': '东门城墙年久失修，需拨款修缮', 'reward': '铜钱', 'icon': '🪙', 'value': 'x20000'},
    {'title': '民间纠纷', 'desc': '两大家族因田产争执，需派人调解', 'reward': '声望', 'icon': '⭐', 'value': '+300'},
  ];

  late List<_Event> _events;

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  void _refreshEvents() {
    final pool = List<Map<String, String>>.from(_allEvents)..shuffle(_rng);
    setState(() {
      _events = pool.take(4).map((e) => _Event(
        title: e['title']!,
        desc: e['desc']!,
        reward: e['reward']!,
        rewardIcon: e['icon']!,
        rewardValue: e['value']!,
      )).toList();
    });
  }

  void _handleEvent(int index) {
    if (_dailyChances <= 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('今日处理次数已用完'), duration: Duration(seconds: 1)));
      return;
    }
    final event = _events[index];
    if (event.completed) return;

    // 模拟事件处理：80% 成功率
    final success = _rng.nextDouble() < 0.8;

    setState(() {
      _dailyChances--;
      event.completed = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              success ? '✅' : '❌',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              success ? '处理成功！' : '处理失败',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: success ? const Color(0xFFD4A84B) : const Color(0xFFA11717))),
            const SizedBox(height: 8),
            Text(event.title, style: const TextStyle(color: Color(0x998B7E6A), fontSize: 14)),
            if (success) ...[
              const SizedBox(height: 4),
              Text('获得: ${event.rewardIcon} ${event.reward} ${event.rewardValue}',
                style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 14),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: success ? const Color(0xFFD4A84B) : const Color(0xFFA11717),
              foregroundColor: const Color(0xFFE2D9CD),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _onRefresh() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('刷新事件', style: TextStyle(color: Color(0xFFE8D5A3))),
        content: const Text('花费 5000 铜钱刷新议事厅事件？\n每日最多刷新 3 次', style: TextStyle(color: Color(0x998B7E6A))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A84B), foregroundColor: const Color(0xFF1A1111)),
            onPressed: () {
              Navigator.pop(ctx);
              _refreshEvents();
            },
            child: const Text('确认刷新'),
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
        title: const Text('议事厅'),
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
                image: DecorationImage(image: AssetImage('assets/images/city/yishitin.png'), fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _CouncilPanel(
              events: _events,
              dailyChances: _dailyChances,
              maxChances: _maxDailyChances,
              onHandleEvent: _handleEvent,
              onRefresh: _onRefresh,
            ),
          ),
        ],
      ),
    );
  }
}

/// 议事厅任务面板
class _CouncilPanel extends StatelessWidget {
  const _CouncilPanel({
    required this.events,
    required this.dailyChances,
    required this.maxChances,
    required this.onHandleEvent,
    required this.onRefresh,
  });

  final List<_Event> events;
  final int dailyChances;
  final int maxChances;
  final ValueChanged<int> onHandleEvent;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xCC1A1111), Color(0xF21A1111)]),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: const Border(top: BorderSide(color: Color(0x40D4A84B), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PanelTitle(),
          const SizedBox(height: 14),
          ...events.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _EventItem(
              title: e.value.title,
              desc: e.value.desc,
              reward: e.value.reward,
              rewardIcon: e.value.rewardIcon,
              rewardValue: e.value.rewardValue,
              completed: e.value.completed,
              onTap: e.value.completed ? null : () => onHandleEvent(e.key),
            ),
          )),
          const SizedBox(height: 6),
          _BottomBar(dailyChances: dailyChances, maxChances: maxChances, onRefresh: onRefresh),
        ],
      ),
    );
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
        const Text('议事厅', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
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

/// 单个事件条目
class _EventItem extends StatelessWidget {
  const _EventItem({
    required this.title,
    required this.desc,
    required this.reward,
    required this.rewardIcon,
    required this.rewardValue,
    required this.completed,
    this.onTap,
  });

  final String title;
  final String desc;
  final String reward;
  final String rewardIcon;
  final String rewardValue;
  final bool completed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: completed ? const Color(0x084CAF50) : const Color(0x10D4A84B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: completed ? const Color(0x104CAF50) : const Color(0x18D4A84B)),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: const Color(0x20D4A84B), borderRadius: BorderRadius.circular(6)),
              child: Center(child: Text(completed ? '✅' : '📋', style: const TextStyle(fontSize: 14))),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(
                    color: completed ? const Color(0x558B7E6A) : const Color(0xFFE8D5A3),
                    fontSize: 14,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  )),
                  const SizedBox(height: 2),
                  Text(desc, style: TextStyle(color: completed ? const Color(0x308B7E6A) : const Color(0x668B7E6A), fontSize: 11)),
                  if (reward.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text('$rewardIcon $reward $rewardValue', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 11)),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: completed ? null : const LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]),
                color: completed ? const Color(0x10FFFFFF) : null,
                borderRadius: BorderRadius.circular(6),
                border: completed ? Border.all(color: const Color(0x10FFFFFF)) : null,
              ),
              child: Text(
                completed ? '已完成' : '前往',
                style: TextStyle(
                  color: completed ? const Color(0x408B7E6A) : const Color(0xFF1A1111),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部操作栏
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.dailyChances, required this.maxChances, required this.onRefresh});
  final int dailyChances;
  final int maxChances;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('今日可处理: $dailyChances/$maxChances', style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
        GestureDetector(
          onTap: onRefresh,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: const Color(0x40D4A84B)), borderRadius: BorderRadius.circular(6)),
            child: const Row(
              children: [
                Icon(Icons.refresh, size: 14, color: Color(0xCCD4A84B)),
                SizedBox(width: 4),
                Text('刷新', style: TextStyle(color: Color(0xCCD4A84B), fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
