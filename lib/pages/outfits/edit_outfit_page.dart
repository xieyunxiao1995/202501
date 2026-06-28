import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/app_theme.dart';
import '../../models/clothing_item.dart';
import '../../models/outfit_entry.dart';
import '../../services/image_storage_service.dart';
import '../../widgets/choice_field.dart';
import '../../widgets/local_image.dart';

class EditOutfitPage extends StatefulWidget {
  const EditOutfitPage({
    super.key,
    this.initialEntry,
    required this.clothingItems,
  });

  final OutfitEntry? initialEntry;
  final List<ClothingItem> clothingItems;

  @override
  State<EditOutfitPage> createState() => _EditOutfitPageState();
}

class _EditOutfitPageState extends State<EditOutfitPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late DateTime _date;
  late String _occasion;
  late String _mood;
  late String _imagePath;
  late Set<String> _selectedClothingIds;
  bool _selectingImage = false;

  @override
  void initState() {
    super.initState();
    final entry = widget.initialEntry;
    _titleController = TextEditingController(text: entry?.title ?? '');
    _notesController = TextEditingController(text: entry?.notes ?? '');
    _date = entry?.date ?? DateTime.now();
    _occasion = entry?.occasion ?? '通勤';
    _mood = entry?.mood ?? '轻松';
    _imagePath = entry?.imagePath ?? '';
    _selectedClothingIds = {...?entry?.clothingItemIds};
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _selectingImage = true);
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 88,
        maxWidth: 1800,
      );
      if (picked == null) return;
      final saved = await ImageStorageService().persistImage(picked.path);
      if (mounted) setState(() => _imagePath = saved);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('无法读取这张图片，请检查相册权限后重试。')));
      }
    } finally {
      if (mounted) setState(() => _selectingImage = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      helpText: '选择穿搭日期',
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    final entry = OutfitEntry(
      id:
          widget.initialEntry?.id ??
          'outfit_${DateTime.now().microsecondsSinceEpoch}',
      imagePath: _imagePath,
      title: _titleController.text.trim(),
      date: _date,
      occasion: _occasion,
      mood: _mood,
      notes: _notesController.text.trim(),
      clothingItemIds: _selectedClothingIds.toList(growable: false),
    );
    Navigator.of(context).pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.initialEntry == null ? '记录穿搭' : '编辑穿搭'),
          actions: [
            TextButton(onPressed: _save, child: const Text('保存')),
            const SizedBox(width: 8),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1.12,
                  child: Material(
                    color: AppColors.mistBlue,
                    borderRadius: BorderRadius.circular(30),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: _selectingImage ? null : _pickImage,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          LocalImage(
                            path: _imagePath,
                            icon: Icons.add_photo_alternate_rounded,
                          ),
                          Positioned(
                            right: 14,
                            bottom: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.ink.withValues(alpha: 0.86),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  if (_selectingImage)
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.photo_library_outlined,
                                      size: 17,
                                      color: Colors.white,
                                    ),
                                  const SizedBox(width: 7),
                                  const Text(
                                    '从相册选择',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: '这套穿搭叫什么？',
                    hintText: '例如：周一清爽通勤',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? '请给这套穿搭起个名字'
                      : null,
                ),
                const SizedBox(height: 14),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.mistBlue,
                    child: Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.primary,
                      size: 19,
                    ),
                  ),
                  title: const Text('穿搭日期'),
                  subtitle: Text('${_date.year}年${_date.month}月${_date.day}日'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 18),
                ChoiceField(
                  label: '场合',
                  options: const ['通勤', '休闲', '约会', '运动', '旅行'],
                  value: _occasion,
                  onChanged: (value) => setState(() => _occasion = value),
                ),
                const SizedBox(height: 22),
                ChoiceField(
                  label: '今天的心情',
                  options: const ['轻松', '自信', '开心', '清爽', '慵懒'],
                  value: _mood,
                  onChanged: (value) => setState(() => _mood = value),
                ),
                if (widget.clothingItems.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Text(
                    '关联衣橱单品',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.clothingItems
                        .map((item) {
                          final selected = _selectedClothingIds.contains(
                            item.id,
                          );
                          return FilterChip(
                            selected: selected,
                            label: Text(item.name),
                            showCheckmark: selected,
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _selectedClothingIds.add(item.id);
                                } else {
                                  _selectedClothingIds.remove(item.id);
                                }
                              });
                            },
                          );
                        })
                        .toList(growable: false),
                  ),
                ],
                const SizedBox(height: 22),
                TextFormField(
                  controller: _notesController,
                  minLines: 4,
                  maxLines: 7,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    labelText: '写点什么',
                    hintText: '天气、灵感、舒适度，或这一天的小故事……',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('保存这套穿搭'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
