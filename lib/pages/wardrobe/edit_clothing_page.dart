import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';

class EditClothingPage extends StatefulWidget {
  final ClothingItem? item;
  const EditClothingPage({super.key, this.item});
  @override
  State<EditClothingPage> createState() => _EditClothingPageState();
}

class _EditClothingPageState extends State<EditClothingPage> {
  late final TextEditingController nameController;
  late final TextEditingController noteController;
  late String type, color, style, season, occasion, image;
  late bool isLocalImage;
  bool saving = false;
  final types = ['上衣', '裙装', '裤装', '外套', '鞋包', '配饰'];
  final colors = ['米色', '黑色', '白色', '浅紫', '蓝色', '粉色'];
  final styles = ['简约', '通勤', '甜酷', '复古', '运动', '休闲'];
  final seasons = ['春秋', '夏季', '冬季', '四季'];
  final occasions = ['通勤', '约会', '旅行', '日常'];
  final presetImages = const [
    'assets/cream_button_down_shirt_product.png',
    'assets/black_wide_leg_trousers_v1.png',
    'assets/cream_pleated_midi_skirt_v1.png',
    'assets/beige_structured_handbag_with_clasp_v1.png',
    'assets/white_sneakers_product.png',
  ];

  @override
  void initState() {
    super.initState();
    final item =
        widget.item ??
        const ClothingItem(
          id: '',
          name: '',
          type: '上衣',
          image: 'assets/cream_button_down_shirt_product.png',
        );
    nameController = TextEditingController(text: item.name);
    noteController = TextEditingController(text: item.note);
    type = item.type;
    color = item.color;
    style = item.style;
    season = item.season;
    occasion = item.occasion;
    image = item.image;
    isLocalImage = item.isLocalImage;
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (file != null && mounted) {
      setState(() {
        image = file.path;
        isLocalImage = true;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '选择图片来源',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF8E68D9)),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF8E68D9)),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (saving) return;
    if (nameController.text.trim().isEmpty) return;
    setState(() => saving = true);
    final item =
        (widget.item ??
                ClothingItem(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  name: '',
                  type: type,
                  image: image,
                ))
            .copyWith(
              name: nameController.text.trim(),
              type: type,
              color: color,
              style: style,
              season: season,
              occasion: occasion,
              image: image,
              isLocalImage: isLocalImage,
              note: noteController.text.trim(),
            );
    await LocalStorage().saveClothingItem(item);
    if (mounted) Navigator.pop(context, item);
  }

  Widget _select(
    String label,
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
  ) => DropdownButtonFormField<String>(
    initialValue: options.contains(value) ? value : options.first,
    items: options
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList(),
    onChanged: (v) {
      if (v != null) setState(() => onChanged(v));
    },
    decoration: InputDecoration(labelText: label),
  );

  @override
  Widget build(BuildContext context) => PageFrame(
    title: widget.item == null ? '添加衣物' : '编辑单品',
    subtitle: '完善衣物信息，让搭配更准确',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      // 图片选择区域
      SoftCard(
        child: Column(
          children: [
            // 当前选中的图片预览
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _showImageSourceDialog,
              child: Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F4FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8E68D9).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: isLocalImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(image),
                          fit: BoxFit.cover,
                          errorBuilder: (_, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Center(
                            child: SmartImageWidget(
                              path: image,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '更换图片',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
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
            const SizedBox(height: 12),
            // 预设图片选择（仅当非本地图片时显示）
            if (!isLocalImage)
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    for (final asset in presetImages)
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => setState(() {
                            image = asset;
                            isLocalImage = false;
                          }),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: image == asset
                                  ? const Color(0xFFF0E7FF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: image == asset
                                  ? Border.all(color: const Color(0xFF8E68D9))
                                  : null,
                            ),
                            child: SmartImageWidget(path: asset),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: '名称'),
      ),
      Row(
        children: [
          Expanded(child: _select('分类', type, types, (v) => type = v)),
          const SizedBox(width: 12),
          Expanded(child: _select('颜色', color, colors, (v) => color = v)),
        ],
      ),
      Row(
        children: [
          Expanded(child: _select('风格', style, styles, (v) => style = v)),
          const SizedBox(width: 12),
          Expanded(child: _select('季节', season, seasons, (v) => season = v)),
        ],
      ),
      _select('适合场景', occasion, occasions, (v) => occasion = v),
      TextField(
        controller: noteController,
        maxLines: 2,
        decoration: const InputDecoration(
          labelText: '备注',
          hintText: '例如：薄款、适合叠穿',
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: saving ? null : _save,
          child: Text(saving ? '保存中…' : '保存单品'),
        ),
      ),
    ],
  );
}
