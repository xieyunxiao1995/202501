import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';
import '../wardrobe/select_items_page.dart';

class QuickRecordPage extends StatefulWidget {
  const QuickRecordPage({super.key});
  @override
  State<QuickRecordPage> createState() => _QuickRecordPageState();
}

class _QuickRecordPageState extends State<QuickRecordPage> {
  final storage = LocalStorage();
  final picker = ImagePicker();
  final moodOptions = ['😊', '😌', '🙂', '✨', '😎'];
  final moodLabels = ['开心', '放松', '平静', '期待', '自信'];
  final tagOptions = ['通勤', '简约', '休闲', '约会', '温柔', '舒适', '奶油色'];
  String selectedMood = '😊';
  final Set<String> tags = {'通勤', '简约'};
  List<ClothingItem> selectedItems = [];
  bool saving = false;
  XFile? photoFile;

  @override
  void initState() {
    super.initState();
    _autoRecommend();
  }

  Future<void> _autoRecommend() async {
    final items = await storage.readWardrobe();
    if (mounted && items.isNotEmpty) {
      setState(() => selectedItems = items.take(3).toList());
    }
  }

  String get _todayDate {
    final now = DateTime.now();
    return '${now.month}月${now.day}日';
  }

  String get _todayWeekday {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return '星期${weekdays[DateTime.now().weekday - 1]}';
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null && mounted) {
        setState(() => photoFile = image);
      }
    } catch (e) {
      if (mounted) {
        showAppSnackBar(context, '无法获取图片：$e', icon: Icons.error_outline);
      }
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '添加穿搭照片',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.photo_camera_rounded,
                      label: '拍照',
                      color: const Color(0xFFFFE8E5),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.photo_library_rounded,
                      label: '从相册选择',
                      color: const Color(0xFFEFE6FF),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              if (photoFile != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => photoFile = null);
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      '移除当前照片',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (saving) return;
    setState(() => saving = true);
    final now = DateTime.now();
    final moodIndex = moodOptions.indexOf(selectedMood);

    // 照片持久化：将临时文件复制到应用文档目录
    String image;
    bool isLocal = false;
    if (photoFile != null) {
      image = await _persistPhoto(photoFile!.path);
      isLocal = true;
    } else if (selectedItems.isNotEmpty) {
      image = selectedItems.first.image;
      isLocal = selectedItems.first.isLocalImage;
    } else {
      image = AssetPaths.blazer;
    }

    final entry = DiaryEntry(
      id: now.millisecondsSinceEpoch.toString(),
      date: '${now.month}.${now.day}',
      image: image,
      isLocalImage: isLocal,
      mood: moodLabels[moodIndex >= 0 ? moodIndex : 0],
      weather: '晴 18~26°C',
      tags: tags.toList(),
      clothingIds: selectedItems.map((item) => item.id).toList(),
      source: 'manual',
    );
    await storage.saveDiaryEntry(entry);
    if (!mounted) return;
    Navigator.pop(context, entry);
  }

  /// 将 picker 返回的临时照片复制到文档目录，避免缓存清理后丢失
  Future<String> _persistPhoto(String tempPath) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final folder = Directory('${dir.path}/outfit_photos');
      if (!folder.existsSync()) folder.createSync(recursive: true);
      final target =
          '${folder.path}/outfit_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(tempPath).copy(target);
      return target;
    } catch (_) {
      return tempPath;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppBackground.base,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: AppColors.ink),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '快速记录',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),
      centerTitle: true,
    ),
    body: AppBackground(
      child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 日期与天气概览
          SoftCard(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5E6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.wb_sunny_rounded,
                    color: Color(0xFFFFA726),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_todayDate · $_todayWeekday',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '晴 18~26°C · 适合出门',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8EE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '已自动填入',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF4C9A67),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 今日穿搭照片
          const Text(
            '今日穿搭照片',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _showImageSourcePicker,
            child: SoftCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: photoFile != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(photoFile!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            // 渐变遮罩
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: .4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // 底部操作栏
                            Positioned(
                              bottom: 10,
                              left: 12,
                              right: 12,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: .9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 13,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '已添加',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: _showImageSourcePicker,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: .9),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.swap_horiz,
                                            size: 13,
                                            color: AppColors.deepLavender,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '更换',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.deepLavender,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFF8F4), Color(0xFFF8F5FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F0FF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo_outlined,
                                  color: AppColors.lavender,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                '点击添加今日穿搭照片',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                '支持拍照或从相册选择',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _MiniAction(
                                    icon: Icons.photo_camera_rounded,
                                    label: '拍照',
                                  ),
                                  const SizedBox(width: 24),
                                  _MiniAction(
                                    icon: Icons.photo_library_rounded,
                                    label: '相册',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 选择衣橱单品
          Row(
            children: [
              const Text(
                '今日单品',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  final items = await Navigator.push<List<ClothingItem>>(
                    context,
                    FadeSlideRoute(
                      builder: (_) => SelectItemsPage(
                        selectedIds:
                            selectedItems.map((item) => item.id).toList(),
                      ),
                    ),
                  );
                  if (items != null && mounted) {
                    setState(() => selectedItems = items);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  child: Text(
                    '从衣橱选择',
                    style: TextStyle(
                      color: AppColors.lavender,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SoftCard(
            child: selectedItems.isEmpty
                ? const SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        '点击上方「从衣橱选择」添加单品',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        for (final item in selectedItems)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SmartImageWidget(
                                      path: item.image,
                                      isLocal: item.isLocalImage,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
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

          const SizedBox(height: 20),

          // 心情
          const Text(
            '今日心情',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          SoftCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < moodOptions.length; i++)
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () =>
                        setState(() => selectedMood = moodOptions[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      height: 62,
                      decoration: BoxDecoration(
                        color: selectedMood == moodOptions[i]
                            ? const Color(0xFFF6F0FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selectedMood == moodOptions[i]
                              ? AppColors.lavender
                              : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            moodOptions[i],
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            moodLabels[i],
                            style: TextStyle(
                              fontSize: 9,
                              color: selectedMood == moodOptions[i]
                                  ? AppColors.deepLavender
                                  : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 标签
          const Text(
            '穿搭标签',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in tagOptions)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => setState(
                    () => tags.contains(tag) ? tags.remove(tag) : tags.add(tag),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: tags.contains(tag)
                          ? const Color(0xFFF6F0FF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: tags.contains(tag)
                            ? AppColors.lavender
                            : const Color(0xFFE8E0EE),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: tags.contains(tag)
                            ? AppColors.deepLavender
                            : AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 28),

          // 保存按钮
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: saving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.deepLavender,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_rounded, size: 20),
              label: Text(
                saving ? '保存中…' : '保存今日穿搭',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
    ),
  );
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.deepLavender),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.deepLavender,
            ),
          ),
        ],
      ),
    ),
  );
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: AppColors.lavender),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.lavender,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
