import 'package:flutter/material.dart';

/// 个人中心页面
///
/// 展示角色信息：头像、名称、等级、经验条、关卡进度、战力等。
class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  /// 模拟数据 — 后续替换为实际数据源
  static const _playerName = '主公';
  static const _playerLevel = 1;
  static const _currentExp = 340;
  static const _maxExp = 1000;
  static const _power = 1280;
  static const _chapterName = '第1章';
  static const _stageName = '黄巾之乱';

  @override
  Widget build(BuildContext context) {
    const expPercent = _currentExp / _maxExp;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1614),
      appBar: AppBar(
        title: const Text('个人中心'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // ==================== 头像 + 名称区 ====================
            const SizedBox(height: 8),
            // 头像
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD4A84B),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4A84B).withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 38,
                backgroundColor: Color(0x406A0F0F),
                child: Icon(
                  Icons.person,
                  color: Color(0xFFD4A84B),
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 名称
            Text(
              _playerName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE2D9CD),
              ),
            ),
            const SizedBox(height: 4),
            // 等级
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A84B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4A84B).withValues(alpha: 0.3),
                ),
              ),
              child: const Text(
                'Lv.$_playerLevel',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD4A84B),
                ),
              ),
            ),

            // ==================== 经验条 ====================
            const SizedBox(height: 20),
            _SectionCard(
              title: '经验值',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'EXP',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0x998B7E6A),
                        ),
                      ),
                      Text(
                        '$_currentExp / $_maxExp',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0x998B7E6A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: expPercent,
                      minHeight: 8,
                      backgroundColor: const Color(0x306A0F0F),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFD4A84B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================== 基础信息 ====================
            const SizedBox(height: 12),
            _SectionCard(
              title: '基础信息',
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.local_fire_department,
                    label: '战力',
                    value: '$_power',
                  ),
                  const _Divider(),
                  _InfoRow(
                    icon: Icons.map,
                    label: '当前进度',
                    value: '$_chapterName · $_stageName',
                  ),
                  const _Divider(),
                  _InfoRow(
                    icon: Icons.star,
                    label: '等级',
                    value: 'Lv.$_playerLevel',
                  ),
                ],
              ),
            ),

            // ==================== 战斗统计 ====================
            const SizedBox(height: 12),
            _SectionCard(
              title: '战斗统计',
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.emoji_events,
                    label: '总战斗次数',
                    value: '42',
                  ),
                  const _Divider(),
                  _InfoRow(
                    icon: Icons.thumb_up,
                    label: '胜利',
                    value: '38',
                  ),
                  const _Divider(),
                  _InfoRow(
                    icon: Icons.trending_up,
                    label: '胜率',
                    value: '90.5%',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ==================== 子组件 ====================

/// 区块卡片
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xCC1A1A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x306A0F0F),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD4A84B),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// 信息行
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFD4A84B)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0x998B7E6A),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE2D9CD),
            ),
          ),
        ],
      ),
    );
  }
}

/// 分割线
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Color(0x1A6A0F0F),
      height: 1,
      thickness: 1,
    );
  }
}
