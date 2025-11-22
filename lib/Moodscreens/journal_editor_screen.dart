import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../Moodmodels/journal.dart';
import '../Moodmodels/emotion_tag.dart';
import '../Moodservices/storage_service.dart';

class JournalEditorScreen extends StatefulWidget {
  final StorageService storageService;
  const JournalEditorScreen({super.key, required this.storageService});

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _imageUrl;
  final List<String> _selectedTags = [];
  bool _isPrivate = true;
  bool _isSaving = false;

  final List<EmotionTag> _availableTags = EmotionTag.getAllTags();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() {
          _imageUrl = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('选择图片失败')),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _imageUrl = null;
    });
  }

  void _toggleTag(EmotionTag tag) {
    setState(() {
      if (_selectedTags.contains(tag.name)) {
        _selectedTags.remove(tag.name);
      } else {
        if (_selectedTags.length < 3) {
          _selectedTags.add(tag.name);
        }
      }
    });
  }

  Future<void> _saveJournal() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先写点什么')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final journal = Journal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Journal Entry',
        content: _contentController.text.trim(),
        imageUrl: _imageUrl,
        emotionTags: _selectedTags,
        isPrivate: _isPrivate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: 'current_user', // 当前用户ID，实际应用中应该从用户认证系统获取
      );

      await widget.storageService.saveJournal(journal);

      if (mounted) {
        Navigator.pop(context, journal);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('保存日记失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF000000),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                '新日记',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveJournal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A7CF5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            '发布',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF000000),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _imageUrl != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(_imageUrl!),
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: _removeImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey[800]!,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 48,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '添加照片',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: '今天想分享什么？',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        color: Color(0xFFD0D0D0),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFF2A2A2A)),
                    const SizedBox(height: 16),
                    const Text(
                      '情绪标签',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag.name);
                        final color = Color(int.parse('0xFF${tag.color.substring(1)}'));
                        return GestureDetector(
                          onTap: () => _toggleTag(tag),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withValues(alpha: 0.2)
                                  : const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? color : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '#${tag.displayName}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? color
                                    : Colors.grey[500],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8A7CF5).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF8A7CF5).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isPrivate ? Icons.lock_outline : Icons.public,
                            color: const Color(0xFF8A7CF5),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '隐私设置',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                Text(
                                  _isPrivate
                                      ? '私密日记 - 仅自己可见'
                                      : '公开日记 - 他人可见',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isPrivate,
                            onChanged: (value) {
                              setState(() {
                                _isPrivate = value;
                              });
                            },
                            thumbColor: WidgetStateProperty.all(
                              const Color(0xFF8A7CF5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
