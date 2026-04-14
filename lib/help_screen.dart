import 'package:flutter/material.dart';

/// 使用帮助页面
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('使用帮助'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpCard(
            icon: '🎮',
            title: '游戏基础',
            color: const Color(0xFF00FF88),
            items: const [
              HelpItem(
                question: 'Q: 游戏目标是什么？',
                answer: 'A: 通过合并能量节点提升等级，在轨道上部署防御塔，阻止敌人到达基地。完成关卡以解锁更多内容！',
              ),
              HelpItem(
                question: 'Q: 如何开始游戏？',
                answer: 'A: 在主界面点击"开始游戏"按钮即可。首次游玩建议先查看"新手教程"了解基本操作。',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            icon: '🔗',
            title: '合并系统',
            color: const Color(0xFF00C3FF),
            items: const [
              HelpItem(
                question: 'Q: 如何进行合并？',
                answer: 'A: 拖动相同等级的能量节点到彼此身上即可合并。两个相同等级的节点合并后会变成更高一级的节点。',
              ),
              HelpItem(
                question: 'Q: 合并有什么好处？',
                answer:
                    'A: 合并可以获得更高阶的能量节点，产生更多星尘。高阶节点还可以转化为更强大的防御塔！连续合并还能获得连击加成。',
              ),
              HelpItem(
                question: 'Q: 什么是连击（Combo）？',
                answer:
                    'A: 在短时间内连续进行合并操作会积累连击数。连击数越高，获得的分数倍率越高。达到5连击时还会触发"超载模式"，获得额外奖励！',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            icon: '🗼',
            title: '防御塔系统',
            color: const Color(0xFFB700FF),
            items: const [
              HelpItem(
                question: 'Q: 如何部署防御塔？',
                answer: 'A: 合并到T2及以上的能量节点时，可以选择将其转化为防御塔部署在轨道上。防御塔会自动攻击轨道上的敌人。',
              ),
              HelpItem(
                question: 'Q: 防御塔有哪些类型？',
                answer:
                    'A: 不同阶的能量节点转化后会有不同效果：\n• T2脉冲塔：基础攻击\n• T3引力塔：减速敌人\n• T4相位塔：概率二次攻击\n• T5星环塔：溅射伤害',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            icon: '📋',
            title: '关卡与任务',
            color: const Color(0xFFFFEA00),
            items: const [
              HelpItem(
                question: 'Q: 关卡如何解锁？',
                answer:
                    'A: 需要通过当前关卡才能解锁下一关。游戏共有9大章节81个关卡，每个关卡难度递增。通关后会根据表现给予1-3星评价。',
              ),
              HelpItem(
                question: 'Q: 每日任务是什么？',
                answer: 'A: 每日任务会在每天刷新，完成任务可以获得星尘奖励。每周任务则有更丰厚的奖励，建议尽量完成！',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            icon: '⬆️',
            title: '升级系统',
            color: const Color(0xFFFF00AA),
            items: const [
              HelpItem(
                question: 'Q: 角色升级有什么用？',
                answer:
                    'A: 角色升级可以永久提升基础属性，如基地HP、攻击速度、伤害加成等。使用星尘即可升级，建议优先提升核心属性。',
              ),
              HelpItem(
                question: 'Q: 卡片系统是怎样的？',
                answer:
                    'A: 卡片提供额外的被动加成。通过收集卡片碎片可以合成新卡片，升级卡片需要消耗星尘和碎片。卡片分为R、SR、SSR三个稀有度。',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            icon: '💡',
            title: '游戏技巧',
            color: const Color(0xFFFF6644),
            items: const [
              HelpItem(
                question: 'Q: 有什么新手建议？',
                answer:
                    'A: 1. 优先合并生成高阶节点，效率更高\n2. 注意保持连击，分数倍率很可观\n3. 合理分配星尘用于升级\n4. 每60秒的"协议选择"要仔细考虑\n5. 多尝试不同的塔组合',
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required String icon,
    required String title,
    required Color color,
    required List<HelpItem> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.expand(
            (item) => [
              _buildQuestion(item.question),
              const SizedBox(height: 6),
              _buildAnswer(item.answer),
              const SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(String question) {
    return Text(
      question,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAnswer(String answer) {
    return Text(
      answer,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFFAABBCC),
        height: 1.6,
      ),
    );
  }
}

class HelpItem {
  final String question;
  final String answer;

  const HelpItem({required this.question, required this.answer});
}
