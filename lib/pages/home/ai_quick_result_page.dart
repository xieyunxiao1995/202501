import 'package:flutter/material.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';

class AiQuickResultPage extends StatefulWidget {
  const AiQuickResultPage({super.key});
  @override
  State<AiQuickResultPage> createState() => _AiQuickResultPageState();
}

class _AiQuickResultPageState extends State<AiQuickResultPage> {
  int resultIndex = 0;
  bool generating = true;
  List<ClothingItem> wardrobeItems = [];

  static const _results = [
    _OutfitResult(
      title: '奶油色轻盈通勤风',
      image: 'assets/fashion_character_cream_top_blue_jeans.png',
      items: [
        ('assets/cream_tweed_jacket_product.png', '米色西装'),
        ('assets/cream_button_down_shirt_product.png', '白衬衫'),
        ('assets/black_wide_leg_trousers_v1.png', '阔腿裤'),
        ('assets/beige_structured_handbag_with_clasp_v1.png', '浅色手提包'),
      ],
      reasons: ['天气温和，适合轻薄叠穿', '适合办公场景', '符合你的简约偏好'],
      tags: ['通勤', '简约', '奶油色'],
    ),
    _OutfitResult(
      title: '温柔休闲周末风',
      image: 'assets/fashion_character_lavender_cardigan_skirt.png',
      items: [
        ('assets/lavender_v_neck_cardigan_product.png', '紫色开衫'),
        ('assets/pink_bow_blouse_product.png', '粉色衬衫'),
        ('assets/cream_pleated_midi_skirt_v1.png', '百褶裙'),
        ('assets/beige_structured_handbag_with_clasp_v1.png', '米色手提包'),
      ],
      reasons: ['周末放松的好选择', '色彩柔和治愈', '适合与朋友下午茶'],
      tags: ['休闲', '温柔', '浅色'],
    ),
    _OutfitResult(
      title: '活力日常出行风',
      image: 'assets/fashion_character_floral_dress_lavender_cardigan.png',
      items: [
        ('assets/pink_floral_long_sleeve_dress_product.png', '碎花连衣裙'),
        ('assets/white_sneakers_product.png', '白色运动鞋'),
        ('assets/lavender_purple_shoulder_bag_v1.png', '浅色手提包'),
      ],
      reasons: ['舒适透气适合出行', '花色活泼有活力', '轻便好搭配'],
      tags: ['出行', '舒适', '活力'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadAndGenerate();
  }

  Future<void> _loadAndGenerate() async {
    wardrobeItems = await LocalStorage().readWardrobe();
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => generating = false);
  }

  _OutfitResult get _current => _results[resultIndex % _results.length];

  Future<void> _shuffle() async {
    setState(() => generating = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        resultIndex++;
        generating = false;
      });
    }
  }

  Future<void> _recordToday() async {
    final now = DateTime.now();
    final result = _current;
    final entry = DiaryEntry(
      id: now.millisecondsSinceEpoch.toString(),
      date: '${now.month}.${now.day}',
      image: result.image,
      mood: '期待',
      weather: '晴 18~26°C',
      tags: result.tags,
      clothingIds: wardrobeItems.map((e) => e.id).toList(),
      note: '来自 AI 一键生成',
      source: 'ai',
    );
    await LocalStorage().saveDiaryEntry(entry);
    if (!mounted) return;
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final result = _current;
    return Scaffold(
      backgroundColor: AppBackground.base,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AI 搭配推荐',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        centerTitle: true,
      ),
      body: AppBackground(
        child: generating
          ? const _GeneratingView()
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 天气与风格概览
                  SoftCard(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: Row(
                      children: [
                        Image.asset(AssetPaths.sunny, width: 28, height: 28),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            '晴 18~26°C · 已根据你的偏好生成',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F6ED),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '92%匹配',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF4C9A67),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 搭配标题
                  Text(
                    '今日推荐',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 搭配大图
                  SoftCard(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            DecoratedBox(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFF8F4),
                                    Color(0xFFF8F5FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            Image.asset(
                              result.image,
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, err, st) => const Icon(
                                Icons.checkroom,
                                size: 64,
                                color: AppColors.lavender,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 标签
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final tag in result.tags) Pill(tag),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 搭配理由
                  const Text(
                    '搭配理由',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  SoftCard(
                    child: Column(
                      children: [
                        for (final reason in result.reasons)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppColors.lavender,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    reason,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 包含单品
                  const Text(
                    '包含单品',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  SoftCard(
                    child: SizedBox(
                      height: 110,
                      child: Row(
                        children: [
                          for (final item in result.items)
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: AssetImageWidget(item.$1),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.$2,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _shuffle,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.lavender,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(
                              Icons.refresh_rounded,
                              size: 18,
                              color: AppColors.deepLavender,
                            ),
                            label: const Text(
                              '换一套',
                              style: TextStyle(
                                color: AppColors.deepLavender,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: _recordToday,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.deepLavender,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.check_rounded, size: 18),
                            label: const Text(
                              '记录今天',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
        ),
    );
  }
}

class _GeneratingView extends StatefulWidget {
  const _GeneratingView();
  @override
  State<_GeneratingView> createState() => _GeneratingViewState();
}

class _GeneratingViewState extends State<_GeneratingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: Tween<double>(begin: 1, end: 1.1).animate(
            CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
          ),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.lavender, AppColors.deepLavender],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lavender.withValues(alpha: .3),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'AI 正在为你生成搭配…',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '正在读取天气、衣橱和风格偏好',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
      ],
    ),
  );
}

class _OutfitResult {
  final String title;
  final String image;
  final List<(String, String)> items;
  final List<String> reasons;
  final List<String> tags;

  const _OutfitResult({
    required this.title,
    required this.image,
    required this.items,
    required this.reasons,
    required this.tags,
  });
}
