import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';

class AiHistoryDetailPage extends StatefulWidget {
  final AiHistoryEntry entry;
  const AiHistoryDetailPage({super.key, required this.entry});
  @override
  State<AiHistoryDetailPage> createState() => _AiHistoryDetailPageState();
}

class _AiHistoryDetailPageState extends State<AiHistoryDetailPage> {
  bool collected = false;

  static const _items = [
    ('assets/cream_tweed_jacket_product.png', '米色西装', '外套'),
    ('assets/cream_button_down_shirt_product.png', '白衬衫', '内搭'),
    ('assets/black_wide_leg_trousers_v1.png', '阔腿裤', '下装'),
    ('assets/lavender_purple_shoulder_bag_v1.png', '浅色手提包', '配饰'),
  ];

  @override
  Widget build(BuildContext context) => PageFrame(
    title: widget.entry.title,
    subtitle: '${widget.entry.date} · AI生成方案',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      // ── 搭配单品展示 ──
      SlideFadeIn(
        index: 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.lavender.withValues(alpha: .10),
                AppColors.lavender.withValues(alpha: .03),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.lavender.withValues(alpha: .15)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.lavender, AppColors.deepLavender],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'AI 推荐',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.entry.season,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.deepLavender.withValues(alpha: .7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.05,
                children: [
                  for (final (asset, name, slot) in _items)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lavender.withValues(alpha: .08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                              child: AssetImageWidget(asset),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  slot,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      // ── 生成条件 ──
      SlideFadeIn(index: 1, child: const SectionTitle(title: '生成条件')),
      SlideFadeIn(
        index: 2,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ConditionChip(icon: Icons.place_outlined, label: '场景', value: widget.entry.scene),
            _ConditionChip(icon: Icons.style_outlined, label: '风格', value: widget.entry.style),
            _ConditionChip(icon: Icons.wb_sunny_outlined, label: '天气', value: '18~26°C 多云转晴'),
            _ConditionChip(icon: Icons.calendar_month_outlined, label: '季节', value: widget.entry.season),
          ],
        ),
      ),
      // ── 搭配说明 ──
      SlideFadeIn(index: 3, child: const SectionTitle(title: '搭配说明')),
      SlideFadeIn(
        index: 4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.lavender.withValues(alpha: .12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.lavender.withValues(alpha: .10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tips_and_updates_outlined,
                  size: 16,
                  color: AppColors.deepLavender,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '这套搭配兼顾了温度、场景与个人偏好，颜色柔和统一，米色与浅紫形成低饱和的层次感，适合日常通勤复用。',
                  style: TextStyle(height: 1.7, fontSize: 13, color: AppColors.ink),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 6),
      // ── 操作按钮 ──
      SlideFadeIn(
        index: 5,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.refresh, size: 17),
                label: const Text('再生成一套'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  setState(() => collected = !collected);
                  showAppSnackBar(
                    context,
                    collected ? '已收藏该方案' : '已取消收藏',
                    icon: collected ? Icons.bookmark : Icons.bookmark_border,
                  );
                },
                icon: Icon(collected ? Icons.bookmark : Icons.bookmark_add_outlined, size: 17),
                label: Text(collected ? '已收藏' : '收藏方案'),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ConditionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ConditionChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.lavender.withValues(alpha: .18)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.lavender),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ],
    ),
  );
}
