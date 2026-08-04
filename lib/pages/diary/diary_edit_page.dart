import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';

class DiaryEditPage extends StatefulWidget {
  final DiaryEntry entry;
  const DiaryEditPage({super.key, required this.entry});
  @override
  State<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends State<DiaryEditPage> {
  late String mood, occasion;
  late final TextEditingController noteController;
  late Set<String> tags;
  bool saving = false;
  final moods = ['开心', '放松', '平静', '期待'];
  final occasions = ['日常', '通勤', '约会', '旅行'];
  final tagOptions = ['通勤', '简约', '奶油色', '舒适', '约会', '休闲'];
  @override
  void initState() {
    super.initState();
    mood = widget.entry.mood;
    occasion = widget.entry.occasion;
    tags = widget.entry.tags.toSet();
    noteController = TextEditingController(text: widget.entry.note);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (saving) return;
    setState(() => saving = true);
    final entry = DiaryEntry(
      id: widget.entry.id,
      date: widget.entry.date,
      image: widget.entry.image,
      isLocalImage: widget.entry.isLocalImage,
      mood: mood,
      weather: widget.entry.weather,
      tags: tags.toList(),
      clothingIds: widget.entry.clothingIds,
      note: noteController.text.trim(),
      occasion: occasion,
      source: widget.entry.source,
    );
    await LocalStorage().saveDiaryEntry(entry);
    if (mounted) Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '编辑日记',
    subtitle: widget.entry.date,
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      SlideFadeIn(index: 0, child: const SectionTitle(title: '心情')),
      SlideFadeIn(
        index: 1,
        child: Wrap(
          spacing: 8,
          children: [
            for (final value in moods)
              ChoiceChip(
                label: Text(value),
                selected: mood == value,
                onSelected: (_) => setState(() => mood = value),
              ),
          ],
        ),
      ),
      SlideFadeIn(index: 2, child: const SectionTitle(title: '场景')),
      SlideFadeIn(
        index: 3,
        child: Wrap(
          spacing: 8,
          children: [
            for (final value in occasions)
              ChoiceChip(
                label: Text(value),
                selected: occasion == value,
                onSelected: (_) => setState(() => occasion = value),
              ),
          ],
        ),
      ),
      SlideFadeIn(index: 4, child: const SectionTitle(title: '标签')),
      SlideFadeIn(
        index: 5,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in tagOptions)
              FilterChip(
                label: Text(tag),
                selected: tags.contains(tag),
                onSelected: (v) =>
                    setState(() => v ? tags.add(tag) : tags.remove(tag)),
              ),
          ],
        ),
      ),
      SlideFadeIn(
        index: 6,
        child: TextField(
          controller: noteController,
          maxLines: 4,
          style: const TextStyle(fontSize: 14, decoration: TextDecoration.none),
          decoration: const InputDecoration(
            labelText: '搭配说明',
            labelStyle: TextStyle(decoration: TextDecoration.none),
            hintText: '记录今天为什么喜欢这套搭配',
            hintStyle: TextStyle(fontSize: 13, decoration: TextDecoration.none),
          ),
        ),
      ),
      const SizedBox(height: 8),
      SlideFadeIn(
        index: 7,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: saving ? null : _save,
            child: Text(saving ? '保存中…' : '保存修改'),
          ),
        ),
      ),
    ],
  );
}
