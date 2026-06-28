import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/app_theme.dart';
import '../../models/clothing_item.dart';
import '../../services/image_storage_service.dart';
import '../../widgets/choice_field.dart';
import '../../widgets/local_image.dart';

class EditClothingPage extends StatefulWidget {
  const EditClothingPage({super.key, this.initialItem});

  final ClothingItem? initialItem;

  @override
  State<EditClothingPage> createState() => _EditClothingPageState();
}

class _EditClothingPageState extends State<EditClothingPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _colorController;
  late final TextEditingController _careController;
  late String _category;
  late String _season;
  late bool _isPurchased;
  late String _imagePath;
  bool _selectingImage = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _colorController = TextEditingController(text: item?.color ?? '');
    _careController = TextEditingController(text: item?.careNotes ?? '');
    _category = item?.category ?? '上衣';
    _season = item?.season ?? '四季';
    _isPurchased = item?.isPurchased ?? true;
    _imagePath = item?.imagePath ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _careController.dispose();
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

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      ClothingItem(
        id:
            widget.initialItem?.id ??
            'clothing_${DateTime.now().microsecondsSinceEpoch}',
        imagePath: _imagePath,
        name: _nameController.text.trim(),
        category: _category,
        color: _colorController.text.trim(),
        season: _season,
        isPurchased: _isPurchased,
        careNotes: _careController.text.trim(),
        createdAt: widget.initialItem?.createdAt ?? DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.initialItem == null ? '添加衣物' : '编辑衣物'),
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
                  aspectRatio: 1.05,
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
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: '单品名称',
                    hintText: '例如：雾蓝宽松衬衫',
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? '请填写单品名称' : null,
                ),
                const SizedBox(height: 22),
                ChoiceField(
                  label: '分类',
                  options: const ['上衣', '裤装', '裙装', '外套', '鞋履', '包袋', '配饰'],
                  value: _category,
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _colorController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: '颜色',
                    hintText: '例如：雾蓝、奶油白',
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? '请填写主要颜色' : null,
                ),
                const SizedBox(height: 22),
                ChoiceField(
                  label: '适合季节',
                  options: const ['四季', '春秋', '夏季', '冬季'],
                  value: _season,
                  onChanged: (value) => setState(() => _season = value),
                ),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: const Text('已经拥有'),
                  subtitle: const Text('关闭后会作为愿望清单单品，供 AI 提供购物建议'),
                  value: _isPurchased,
                  onChanged: (value) => setState(() => _isPurchased = value),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _careController,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: '养护备注',
                    hintText: '例如：冷水轻柔洗、不可烘干……',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('保存到衣橱'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
