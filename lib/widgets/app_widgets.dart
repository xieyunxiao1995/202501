import 'dart:io';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/animations/app_animations.dart';

/// 应用全局背景：淡粉渐变 + 柔焦光斑，营造轻盈模糊的氛围感
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  /// 渐变起始色（最浅），用于与其他区域的背景衔接
  static const Color base = Color(0xFFFFF8FB);

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.passthrough,
    children: [
      const Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF8FB),
                Color(0xFFFDF0F6),
                Color(0xFFF7EAF3),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: -70,
        right: -50,
        child: _blob(250, const Color(0x4DFFC7DC)),
      ),
      Positioned(
        top: 230,
        left: -85,
        child: _blob(215, const Color(0x3DE3D2F6)),
      ),
      Positioned(
        bottom: 30,
        right: -65,
        child: _blob(275, const Color(0x38FFD3E5)),
      ),
      child,
    ],
  );

  Widget _blob(double size, Color color) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    ),
  );
}

class PageFrame extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? action;
  final VoidCallback? onAction;
  final List<Widget> children;
  final ScrollController? scrollController;
  const PageFrame({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.onAction,
    required this.children,
    this.scrollController,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppBackground.base,
    body: AppBackground(
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            if (subtitle != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  subtitle!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (action != null)
                        IconButton(
                          onPressed: onAction,
                          icon: Icon(action, color: AppColors.ink),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ...children.map(
                    (child) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState({super.key, required this.message});
  @override
  Widget build(BuildContext context) => SoftCard(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 40,
              color: AppColors.lavender.withValues(alpha: .7),
            ),
            const SizedBox(height: 10),
            Text(message, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    ),
  );
}

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: AppColors.lavender.withValues(alpha: .07),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(18),
      child: child,
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
      ),
      const Spacer(),
      if (action != null)
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onAction,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(
              action!,
              style: const TextStyle(
                color: AppColors.lavender,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
    ],
  );
}

class QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String caption;
  final Color color;
  final VoidCallback? onTap;
  const QuickCard({
    super.key,
    required this.icon,
    required this.title,
    required this.caption,
    required this.color,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: onTap,
    child: SoftCard(
      padding: const EdgeInsets.fromLTRB(14, 15, 12, 14),
      child: SizedBox(
        height: 108,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color,
              child: Icon(icon, color: AppColors.deepLavender, size: 20),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

class Pill extends StatelessWidget {
  final String text;
  final bool green;
  const Pill(this.text, {super.key, this.green = false});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: green ? const Color(0xFFE7F6ED) : const Color(0xFFF3EDF9),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 10,
        color: green ? Colors.green.shade700 : AppColors.deepLavender,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class AssetImageWidget extends StatelessWidget {
  final String path;
  final BoxFit boxFit;
  const AssetImageWidget(this.path, {super.key, this.boxFit = BoxFit.contain});
  @override
  Widget build(BuildContext context) => Image.asset(
    path,
    fit: boxFit,
    errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.checkroom, color: AppColors.lavender, size: 36),
  );
}

/// 智能图片组件：支持 asset 和本地文件图片
class SmartImageWidget extends StatelessWidget {
  final String path;
  final bool isLocal;
  final BoxFit boxFit;

  const SmartImageWidget({
    super.key,
    required this.path,
    this.isLocal = false,
    this.boxFit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (isLocal) {
      return Image.file(
        File(path),
        fit: boxFit,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.grey, size: 36),
      );
    }
    return AssetImageWidget(path, boxFit: boxFit);
  }
}

class StepTitle extends StatelessWidget {
  final String number;
  final String title;
  final String? caption;
  const StepTitle({
    super.key,
    required this.number,
    required this.title,
    this.caption,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 9),
    child: Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: AppColors.lavender,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        ),
        if (caption != null)
          Text(
            '  （$caption）',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
      ],
    ),
  );
}

class ChoiceRow extends StatelessWidget {
  final List<String> items;
  final int selected;
  final ValueChanged<int> onSelect;
  const ChoiceRow({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < items.length; i++)
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == items.length - 1 ? 0 : 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(13),
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: 52,
                decoration: BoxDecoration(
                  color: selected == i ? const Color(0xFFF8F3FF) : Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: selected == i
                        ? AppColors.lavender
                        : const Color(0xFFF0EAF1),
                    width: selected == i ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    style: TextStyle(
                      fontSize: 12,
                      color: selected == i
                          ? AppColors.deepLavender
                          : AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                    child: Text(items[i]),
                  ),
                ),
              ),
            ),
          ),
        ),
    ],
  );
}

class CalendarStrip extends StatelessWidget {
  const CalendarStrip({super.key});

  List<(String, int)> _weekDays() {
    const labels = ['一', '二', '三', '四', '五', '六', '日'];
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final day = monday.add(Duration(days: i));
      return (labels[i], day.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().day;
    final days = _weekDays();
    return SoftCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days
            .map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: e.$2 == today
                    ? BoxDecoration(
                        color: AppColors.lavender,
                        borderRadius: BorderRadius.circular(18),
                      )
                    : null,
                child: Text(
                  '${e.$1}\n${e.$2}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.6,
                    color: e.$2 == today ? Colors.white : AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class DiaryRow extends StatelessWidget {
  final String date, week, asset, weather, mood;
  final List<String> tags;
  final bool isLocal;
  const DiaryRow({
    super.key,
    required this.date,
    required this.week,
    required this.asset,
    required this.weather,
    required this.mood,
    this.tags = const [],
    this.isLocal = false,
  });
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 48,
        child: Column(
          children: [
            Text(date, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(
              week,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 34),
            const Icon(Icons.circle, size: 7, color: AppColors.lavender),
          ],
        ),
      ),
      Expanded(
        child: SoftCard(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: SmartImageWidget(
                    path: asset,
                    isLocal: isLocal,
                    boxFit: isLocal ? BoxFit.cover : BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '今日穿搭 · $mood',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 4,
                      children: [
                        for (final tag in tags.take(3)) Pill(tag),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class Stat extends StatelessWidget {
  final String label, value, suffix;
  const Stat(this.label, this.value, this.suffix, {super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      const SizedBox(height: 5),
      RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.ink),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            TextSpan(text: suffix, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    ],
  );
}

class Category extends StatelessWidget {
  final String asset, title, count;
  const Category({
    super.key,
    required this.asset,
    required this.title,
    required this.count,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Flexible(child: AssetImageWidget(asset, boxFit: BoxFit.contain)),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        Text(count, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    ),
  );
}

class SettingRow extends StatelessWidget {
  final IconData icon;
  final String title, caption;
  const SettingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.caption,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Icon(icon, color: AppColors.lavender),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              Text(
                caption,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      ],
    ),
  );
}

class InspirationCard extends StatelessWidget {
  final String asset, title, caption;
  final VoidCallback? onTap;
  const InspirationCard({
    super.key,
    required this.asset,
    required this.title,
    required this.caption,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => PressableCard(
    onTap: onTap,
    child: SoftCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssetImageWidget(asset, boxFit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 8, 10),
            child: Text(
              caption,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ],
      ),
    ),
  );
}

