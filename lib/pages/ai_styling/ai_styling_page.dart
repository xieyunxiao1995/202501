import 'package:flutter/material.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import 'ai_history_page.dart';
import 'ai_result_detail_page.dart';
import '../wardrobe/items_page.dart';
import '../ai_room/ai_room_page.dart';

class AiStylingPage extends StatefulWidget {
  const AiStylingPage({super.key});
  @override
  State<AiStylingPage> createState() => _AiStylingPageState();
}

class _AiStylingPageState extends State<AiStylingPage> {
  int selectedScene = 0;
  int selectedStyle = 0;
  bool generated = false;
  bool generating = false;
  final scenes = ['通勤', '约会', '旅行', '上课'];
  final styles = ['简约', '甜酷', '运动', '休闲'];
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'AI穿搭',
    action: Icons.auto_awesome_rounded,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: () => Navigator.push(
            context,
            FadeSlideRoute(builder: (_) => const AiHistoryPage()),
          ),
          icon: const Icon(Icons.history, size: 17),
          label: const Text('历史记录'),
        ),
      ),
      SoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.lavender, AppColors.deepLavender],
                    ),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '今日 AI 建议',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _AiTipRow(
              icon: Icons.checkroom_outlined,
              text: '米色西装最近使用较少，可以重新搭配',
            ),
            const _AiTipRow(
              icon: Icons.thermostat_outlined,
              text: '明天 18~26℃，建议轻薄叠穿',
            ),
            const _AiTipRow(
              icon: Icons.auto_awesome_outlined,
              text: '推荐简约通勤风，搭配阔腿裤',
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: generating ? null : _generate,
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: Text(generating ? '正在生成…' : '根据建议生成方案'),
              ),
            ),
          ],
        ),
      ),
      StepTitle(number: '1', title: '上传单品', caption: '可多选'),
      SoftCard(
        child: SizedBox(
          height: 108,
          child: Row(
            children: [
              for (final asset in [
                'assets/cream_button_down_shirt_product.png',
                'assets/pink_bow_blouse_product.png',
                AssetPaths.skirt,
                AssetPaths.beigeBag,
              ])
                Expanded(
                  child: AssetImageWidget(asset, boxFit: BoxFit.contain),
                ),
              const SizedBox(width: 12),
              InkWell(
                borderRadius: BorderRadius.circular(23),
                onTap: () => Navigator.push(
                  context,
                  FadeSlideRoute(builder: (_) => const WardrobeItemsPage()),
                ),
                child: const CircleAvatar(
                  radius: 23,
                  backgroundColor: Color(0xFFF6F0FF),
                  child: Icon(Icons.add, color: AppColors.lavender),
                ),
              ),
            ],
          ),
        ),
      ),
      StepTitle(number: '2', title: '选择场景'),
      ChoiceRow(
        items: scenes,
        selected: selectedScene,
        onSelect: (i) => setState(() => selectedScene = i),
      ),
      StepTitle(number: '3', title: '天气情况'),
      SoftCard(
        child: Row(
          children: [
            Image.asset(AssetPaths.cloudy, width: 32, height: 32),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                '多云转晴\n18~26°C',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const Text('明天  多云', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      StepTitle(number: '4', title: '风格偏好'),
      ChoiceRow(
        items: styles,
        selected: selectedStyle,
        onSelect: (i) => setState(() => selectedStyle = i),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: generating ? null : _generate,
          icon: generating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.auto_awesome, size: 17),
          label: Text(generating ? '正在生成…' : '生成搭配方案'),
        ),
      ),
      if (generating) ...[
        const SizedBox(height: 22),
        const GeneratingShimmer(height: 180),
      ],
      if (generated && !generating) ...[
        const SizedBox(height: 22),
        const SectionTitle(title: 'AI 生成方案'),
        const RevealUp(child: AiResultCard()),
      ],
      const SizedBox(height: 8),
      InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.push(
          context,
          FadeSlideRoute(builder: (_) => const AiRoomPage()),
        ),
        child: SoftCard(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.lavender, AppColors.deepLavender],
                  ),
                ),
                child: Image.asset(AssetPaths.robot, width: 26, height: 26),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '灵感陪聊房',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '和 AI 聊聊今天想穿什么',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    ],
  );

  Future<void> _generate() async {
    setState(() => generating = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final now = DateTime.now();
    await LocalStorage().saveAiHistory(
      AiHistoryEntry(
        id: now.microsecondsSinceEpoch.toString(),
        date: '${now.month}.${now.day}',
        title: '方案 · ${styles[selectedStyle]}${scenes[selectedScene]}风',
        scene: scenes[selectedScene],
        style: styles[selectedStyle],
      ),
    );
    if (mounted) {
      setState(() {
        generating = false;
        generated = true;
      });
    }
  }
}

class AiResultCard extends StatelessWidget {
  const AiResultCard({super.key});
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: () => Navigator.push(
      context,
      FadeSlideRoute(builder: (_) => const AiResultDetailPage()),
    ),
    child: SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '方案一 · 简约通勤风',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Spacer(),
              Pill('92%匹配', green: true),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AssetImageWidget('assets/cream_tweed_jacket_product.png'),
                ),
                Expanded(
                  child: AssetImageWidget('assets/cream_button_down_shirt_product.png'),
                ),
                Expanded(
                  child: AssetImageWidget('assets/black_wide_leg_trousers_v1.png'),
                ),
                Expanded(
                  child: AssetImageWidget('assets/lavender_purple_shoulder_bag_v1.png'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _AiTipRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _AiTipRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, size: 16, color: AppColors.deepLavender),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
      ],
    ),
  );
}
