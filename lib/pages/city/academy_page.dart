import 'package:flutter/material.dart';

/// 学堂页面
///
/// 研究战法，提升战术等级。
class AcademyPage extends StatelessWidget {
  const AcademyPage({super.key});

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
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/city/xuetang.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部面板
          Positioned(left: 0, right: 0, bottom: 0, child: _AcademyPanel()),
        ],
      ),
    );
  }
}

/// 学堂面板
class _AcademyPanel extends StatelessWidget {
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

          // ---- 研究列表 ----
          const _ResearchItem(
            name: '军事理论',
            level: 5,
            maxLevel: 10,
            bonus: '武将攻击 +5%',
            duration: '02:35:45',
            progress: 0.6,
          ),
          const SizedBox(height: 8),
          const _ResearchItem(
            name: '阵法心得',
            level: 3,
            maxLevel: 10,
            bonus: '武将防御 +3%',
            duration: '01:15:30',
            progress: 0.3,
          ),
          const SizedBox(height: 8),
          const _ResearchItem(
            name: '兵法谋略',
            level: 2,
            maxLevel: 10,
            bonus: '武将谋略 +2%',
            duration: '00:45:20',
            progress: 0.15,
          ),
          const SizedBox(height: 14),

          // ---- 研究队列 ----
          _QueueBar(),
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
          '学堂',
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

/// 单个研究条目
class _ResearchItem extends StatelessWidget {
  final String name;
  final int level;
  final int maxLevel;
  final String bonus;
  final String duration;
  final double progress;

  const _ResearchItem({
    required this.name,
    required this.level,
    required this.maxLevel,
    required this.bonus,
    required this.duration,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Column(
        children: [
          // 第一行：名称 + 等级 + 加成
          Row(
            children: [
              // 图标
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0x20D4A84B),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text('📖', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 10),
              // 名称 & 加成
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFFE8D5A3),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      bonus,
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // 等级
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0x30D4A84B),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0x40D4A84B)),
                ),
                child: Text(
                  '$level/$maxLevel',
                  style: const TextStyle(
                    color: Color(0xFFD4A84B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 第二行：进度条 + 时间 + 按钮
          Row(
            children: [
              // 时间
              Row(
                children: [
                  const Icon(Icons.timer, size: 13, color: Color(0x998B7E6A)),
                  const SizedBox(width: 4),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: Color(0xFFE8D5A3),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // 进度条
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: const Color(0x33FFFFFF),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFD4A84B),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // 研究按钮
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '研究',
                  style: TextStyle(
                    color: Color(0xFF1A1111),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 研究队列栏
class _QueueBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '研究队列: ',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 13),
        ),
        const Text(
          '2/2',
          style: TextStyle(
            color: Color(0xFFE8D5A3),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            // TODO: 新增研究队列
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x40D4A84B)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(Icons.add, size: 16, color: Color(0xCCD4A84B)),
            ),
          ),
        ),
      ],
    );
  }
}
