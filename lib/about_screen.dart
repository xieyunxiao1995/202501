import 'package:flutter/material.dart';

/// 关于我们页面
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('关于我们'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00F0FF),
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00F0FF)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo / App图标
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00F0FF).withOpacity(0.4),
                    const Color(0xFF00F0FF).withOpacity(0.05),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F0FF).withOpacity(0.3),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🌌', style: TextStyle(fontSize: 50)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '星轨防线 Orbit Defense',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00F0FF),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'v1.0.0',
              style: TextStyle(fontSize: 14, color: Color(0xFF667788)),
            ),
            const SizedBox(height: 30),
            // 介绍卡片
            _buildInfoCard(
              icon: '🎮',
              title: '游戏介绍',
              content:
                  '《星轨防线》是一款科幻题材的放置合并塔防游戏。玩家将扮演星际守护者，通过合并能量节点、部署防御塔来抵御外星入侵。游戏融合了策略塔防、合并升级、roguelike元素，带来独特的太空冒险体验。',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: '⭐',
              title: '游戏特色',
              content:
                  '• 独特的伪3D轨道视角\n'
                  '• 5阶能量节点合并系统\n'
                  '• 9大章节81个精心设计的关卡\n'
                  '• 丰富的成就与任务系统\n'
                  '• 角色与卡片双升级体系\n'
                  '• 深色空间科幻美学风格',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: '👨‍💻',
              title: '开发团队',
              content:
                  '由独立游戏开发者倾情打造\n'
                  '感谢您对《星轨防线》的支持！',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: '📧',
              title: '联系我们',
              content:
                  '邮箱：support@orbitdefense.game\n'
                  '官方网址：www.orbitdefense.game',
            ),
            const SizedBox(height: 40),
            const Text(
              '感谢您游玩《星轨防线》！',
              style: TextStyle(fontSize: 13, color: Color(0xFF445566)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1A2240)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00F0FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFAABBCC),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
