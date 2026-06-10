import 'package:flutter/material.dart';

/// 议事厅页面
///
/// 接取日常/周常任务，领取奖励。
class CouncilHallPage extends StatelessWidget {
  const CouncilHallPage({super.key});

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
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/city/yishitin.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部任务面板
          Positioned(left: 0, right: 0, bottom: 0, child: _CouncilPanel()),
        ],
      ),
    );
  }
}

/// 议事厅任务面板
class _CouncilPanel extends StatelessWidget {
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
        border: const Border(
          top: BorderSide(color: Color(0x40D4A84B), width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---- 标题 ----
          _PanelTitle(),
          const SizedBox(height: 14),

          // ---- 事件列表 ----
          const _EventItem(title: '张弓事件', reward: '', rewardIcon: ''),
          const SizedBox(height: 8),
          const _EventItem(
            title: '治渠水患',
            reward: '粮食',
            rewardIcon: '🌾',
            rewardValue: 'x50000',
          ),
          const SizedBox(height: 8),
          const _EventItem(
            title: '沼瘴贼才',
            reward: '招贤令',
            rewardIcon: '📜',
            rewardValue: 'x3',
          ),
          const SizedBox(height: 8),
          const _EventItem(
            title: '整顿治安',
            reward: '铜钱',
            rewardIcon: '🪙',
            rewardValue: 'x30000',
          ),
          const SizedBox(height: 14),

          // ---- 底部操作栏 ----
          _BottomBar(),
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
        const Text(
          '议事厅',
          style: TextStyle(
            color: Color(0xFFE8D5A3),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        _goldLine(width: 40),
      ],
    );
  }

  Widget _goldLine({required double width}) {
    return Container(
      width: width,
      height: 1.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)],
        ),
      ),
    );
  }
}

/// 单个事件条目
class _EventItem extends StatelessWidget {
  final String title;
  final String reward;
  final String rewardIcon;
  final String rewardValue;

  const _EventItem({
    required this.title,
    this.reward = '',
    this.rewardIcon = '',
    this.rewardValue = '',
  });

  @override
  Widget build(BuildContext context) {
    final hasReward = reward.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Row(
        children: [
          // 事件图标
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0x20D4A84B),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text('📋', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),
          // 事件标题
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFE8D5A3),
                    fontSize: 14,
                  ),
                ),
                if (hasReward) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(rewardIcon, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        reward,
                        style: const TextStyle(
                          color: Color(0x998B7E6A),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rewardValue,
                        style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // 前往按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '前往',
              style: TextStyle(
                color: Color(0xFF1A1111),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部操作栏
class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '今日可处理: 6/6',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 13),
        ),
        GestureDetector(
          onTap: () {
            // TODO: 刷新事件
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x40D4A84B)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Icon(Icons.refresh, size: 14, color: Color(0xCCD4A84B)),
                SizedBox(width: 4),
                Text(
                  '刷新',
                  style: TextStyle(color: Color(0xCCD4A84B), fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
