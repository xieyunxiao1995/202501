import 'package:flutter/material.dart';

/// 马厩页面
///
/// 培养战马，提升坐骑属性。
class StablePage extends StatelessWidget {
  const StablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('马厩'),
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
                  image: AssetImage('assets/images/city/majiu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部面板
          Positioned(left: 0, right: 0, bottom: 0, child: _StablePanel()),
        ],
      ),
    );
  }
}

/// 马厩面板
class _StablePanel extends StatelessWidget {
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
          // ---- 标题 + 规则说明 ----
          _PanelHeader(),
          const SizedBox(height: 14),

          // ---- 马匹列表 ----
          const _HorseItem(name: '赤兔马', level: 20, bonus: '速度 +25%'),
          const SizedBox(height: 6),
          const _HorseItem(name: '的卢马', level: 15, bonus: '闪避 +20%'),
          const SizedBox(height: 6),
          const _HorseItem(name: '爪黄飞电', level: 12, bonus: '攻击 +15%'),
          const SizedBox(height: 6),
          const _HorseItem(name: '绝影', level: 10, bonus: '暴击 +15%'),
          const SizedBox(height: 14),

          // ---- 底部双按钮 ----
          _BottomActions(),
        ],
      ),
    );
  }
}

/// 面板标题
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
              '马厩',
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

/// 单个马匹条目
class _HorseItem extends StatelessWidget {
  final String name;
  final int level;
  final String bonus;

  const _HorseItem({
    required this.name,
    required this.level,
    required this.bonus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Row(
        children: [
          // 马匹头像
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0x20D4A84B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('🐴', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 10),
          // 名称 / 等级 / 加成
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFFE8D5A3),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x30D4A84B),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0x40D4A84B)),
                      ),
                      child: Text(
                        'Lv.$level',
                        style: const TextStyle(
                          color: Color(0xFFD4A84B),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  bonus,
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // 培养按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '培养',
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

/// 底部双按钮
class _BottomActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO: 马匹图鉴
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x40D4A84B)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '马匹图鉴',
                  style: TextStyle(
                    color: Color(0xCCD4A84B),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO: 马匹商店
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '马匹商店',
                  style: TextStyle(
                    color: Color(0xFF1A1111),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
