import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../widgets/app_widgets.dart';

class StylePreferencesPage extends StatefulWidget {
  const StylePreferencesPage({super.key});
  @override
  State<StylePreferencesPage> createState() => _StylePreferencesPageState();
}

class _StylePreferencesPageState extends State<StylePreferencesPage> {
  final storage = LocalStorage();
  final styles = ['简约', '通勤', '甜酷', '复古', '运动', '休闲'];
  final colors = ['米色', '黑白', '浅紫', '奶油色', '蓝色', '粉色'];
  Set<String> selectedStyles = {};
  Set<String> selectedColors = {};
  @override
  void initState() {
    super.initState();
    Future.wait([
      storage.readPreferredStyles(),
      storage.readPreferredColors(),
    ]).then((values) {
      if (mounted) {
        setState(() {
          selectedStyles = values[0];
          selectedColors = values[1];
        });
      }
    });
  }

  Future<void> _save() async {
    await storage.savePreferences(
      styles: selectedStyles,
      colors: selectedColors,
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '我的风格偏好',
    subtitle: '让 AI 更懂你的穿衣习惯',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      SlideFadeIn(index: 0, child: const SectionTitle(title: '喜欢的风格')),
      SlideFadeIn(
        index: 1,
        child: SoftCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final style in styles)
                FilterChip(
                  label: Text(style),
                  selected: selectedStyles.contains(style),
                  onSelected: (v) => setState(
                    () => v
                        ? selectedStyles.add(style)
                        : selectedStyles.remove(style),
                  ),
                ),
            ],
          ),
        ),
      ),
      SlideFadeIn(index: 2, child: const SectionTitle(title: '喜欢的颜色')),
      SlideFadeIn(
        index: 3,
        child: SoftCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final color in colors)
                FilterChip(
                  label: Text(color),
                  selected: selectedColors.contains(color),
                  onSelected: (v) => setState(
                    () => v
                        ? selectedColors.add(color)
                        : selectedColors.remove(color),
                  ),
                ),
            ],
          ),
        ),
      ),
      SlideFadeIn(
        index: 4,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: _save, child: const Text('保存偏好')),
        ),
      ),
    ],
  );
}
