import 'package:flutter/material.dart';

/// 校场页面
///
/// 训练士兵、提升兵种等级。
class TrainingGroundPage extends StatelessWidget {
  const TrainingGroundPage({super.key});

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
          Positioned(left: 0, right: 0, bottom: 0, child: _TrainingPanel()),
        ],
      ),
    );
  }
}

/// 校场训练面板
class _TrainingPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xCC1A1111), const Color(0xF21A1111)],
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
          // ---- 标题栏 + 规则说明 ----
          _PanelHeader(),
          const SizedBox(height: 14),

          // ---- 兵种选择 ----
          _TroopSelector(),
          const SizedBox(height: 14),

          // ---- 等级 & 加成 ----
          _LevelAndBonus(),
          const SizedBox(height: 14),

          // ---- 训练队列 ----
          _TrainingQueue(),
          const SizedBox(height: 12),

          // ---- 新增队列 ----
          _AddQueuePrompt(),
        ],
      ),
    );
  }
}

/// 面板标题 + 规则说明按钮
class _PanelHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _goldLine(width: 30),
            const SizedBox(width: 10),
            const Text(
              '校场',
              style: TextStyle(
                color: Color(0xFFE8D5A3),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            _goldLine(width: 30),
          ],
        ),
        GestureDetector(
          onTap: () {
            // TODO: 打开规则说明
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x60D4A84B)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '规则说明',
              style: TextStyle(color: Color(0xCCD4A84B), fontSize: 12),
            ),
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
        gradient: LinearGradient(
          colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)],
        ),
      ),
    );
  }
}

/// 兵种选择器
class _TroopSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _TroopTab(icon: '🗡️', label: '步兵', isSelected: true),
        _TroopTab(icon: '🐴', label: '骑兵', isSelected: false),
        _TroopTab(icon: '🏹', label: '弓兵', isSelected: false),
        _TroopTab(icon: '🔱', label: '枪兵', isSelected: false),
      ],
    );
  }
}

class _TroopTab extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;

  const _TroopTab({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0x30D4A84B) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0x80D4A84B) : const Color(0x20FFFFFF),
        ),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFFE8D5A3)
                  : const Color(0x668B7E6A),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// 当前等级 & 加成
class _LevelAndBonus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x18D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x20D4A84B)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '当前等级：',
                style: TextStyle(color: Color(0x998B7E6A), fontSize: 13),
              ),
              const Text(
                '10级',
                style: TextStyle(
                  color: Color(0xFFE8D5A3),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _bonusTag('训练速度 +20%'),
              const SizedBox(width: 6),
              _bonusTag('单次训练数量 +2000'),
            ],
          ),
        ],
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
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 11),
      ),
    );
  }
}

/// 训练队列
class _TrainingQueue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Row(
        children: [
          // 兵种图标
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x20D4A84B),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text('🗡️', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          // 训练信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      '训练中',
                      style: TextStyle(color: Color(0xFF4CAF50), fontSize: 11),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '步兵 x 5000',
                      style: TextStyle(color: Color(0xCC8B7E6A), fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 12, color: Color(0x998B7E6A)),
                    const SizedBox(width: 4),
                    const Text(
                      '02:36:45',
                      style: TextStyle(
                        color: Color(0xFFE8D5A3),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 进度条
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: 0.4,
                          minHeight: 4,
                          backgroundColor: const Color(0x33FFFFFF),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFD4A84B),
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
          // 加速按钮
          GestureDetector(
            onTap: () {
              // TODO: 加速逻辑
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '加速',
                style: TextStyle(
                  color: Color(0xFF1A1111),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 新增训练队列
class _AddQueuePrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: 新增训练队列
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0x30D4A84B),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16, color: Color(0x998B7E6A)),
            SizedBox(width: 4),
            Text(
              '点击新增训练队列',
              style: TextStyle(color: Color(0x998B7E6A), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
