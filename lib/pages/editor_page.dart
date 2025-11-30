import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constants/app_colors.dart';
import '../models/diary_entry.dart';

class EditorPage extends StatefulWidget {
  final Function(String content, bool isPrivate, String? image, Mood mood) onSave;

  const EditorPage({super.key, required this.onSave});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isPrivate = true;
  String? _imagePath;
  Mood _selectedMood = Mood.calm;
  int _wordCount = 0;
  bool _hasDefaultImage = true; // 标记是否使用默认图片

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _wordCount = _controller.text.length;
      });
    });
    // 设置默认图片（使用占位图）
    _imagePath = 'https://picsum.photos/400/300';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _hasDefaultImage = false; // 用户选择了自己的图片
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: GestureDetector(
            onTap: () {
              // 点击卡片区域时隐藏键盘
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 500),
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: AppColors.cardFace,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 头部
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _getMoodColor(_selectedMood).withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _getMoodColor(_selectedMood).withValues(alpha: 0.2),
                                          _getMoodColor(_selectedMood).withValues(alpha: 0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.edit_note_rounded,
                                      size: 24,
                                      color: _getMoodColor(_selectedMood),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    '记录此刻',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.ink,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: AppColors.inkLight.withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formatDate(DateTime.now()),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.inkLight.withValues(alpha: 0.7),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 3,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: AppColors.inkLight.withValues(alpha: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.text_fields,
                                    size: 12,
                                    color: AppColors.inkLight.withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$_wordCount 字',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.inkLight.withValues(alpha: 0.7),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 内容区域
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // 图片预览
                            if (_imagePath != null) ...[
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: _hasDefaultImage
                                        ? Image.network(
                                            _imagePath!,
                                            height: 160,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                height: 160,
                                                decoration: BoxDecoration(
                                                  color: _getMoodColor(_selectedMood).withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  Icons.image_rounded,
                                                  size: 48,
                                                  color: _getMoodColor(_selectedMood).withValues(alpha: 0.5),
                                                ),
                                              );
                                            },
                                          )
                                        : Image.file(
                                            File(_imagePath!),
                                            height: 160,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_hasDefaultImage) {
                                            _imagePath = null;
                                            _hasDefaultImage = false;
                                          } else {
                                            _imagePath = 'https://picsum.photos/400/300';
                                            _hasDefaultImage = true;
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _hasDefaultImage ? Icons.refresh : Icons.delete,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],

                            // 心情选择
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _getMoodColor(_selectedMood).withValues(alpha: 0.08),
                                    _getMoodColor(_selectedMood).withValues(alpha: 0.04),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _getMoodColor(_selectedMood).withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.mood,
                                        size: 16,
                                        color: _getMoodColor(_selectedMood),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '此刻的心情',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.ink.withValues(alpha: 0.7),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildMoodButton(Mood.joy, '开心', Icons.sentiment_very_satisfied),
                                      _buildMoodButton(Mood.calm, '平静', Icons.self_improvement),
                                      _buildMoodButton(Mood.anxiety, '焦虑', Icons.sentiment_dissatisfied),
                                      _buildMoodButton(Mood.sadness, '忧郁', Icons.sentiment_very_dissatisfied),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 文本输入
                            GestureDetector(
                              onTap: () {}, // 阻止点击传播到父级，避免隐藏键盘
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.ink.withValues(alpha: 0.08),
                                  ),
                                ),
                                child: TextField(
                                controller: _controller,
                                maxLines: null,
                                autofocus: true,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.ink,
                                  height: 1.8,
                                  letterSpacing: 0.3,
                                ),
                                decoration: InputDecoration(
                                  hintText: '写下此刻的想法...\n\n可以是今天发生的事，内心的感受，或是任何想要记录的瞬间',
                                  hintStyle: TextStyle(
                                    color: AppColors.ink.withValues(alpha: 0.3),
                                    fontSize: 16,
                                    height: 1.8,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 底部工具栏
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.ink.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // 隐私开关
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPrivate = !_isPrivate;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _isPrivate
                                      ? AppColors.ink.withValues(alpha: 0.08)
                                      : AppColors.joy.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _isPrivate
                                        ? AppColors.ink.withValues(alpha: 0.15)
                                        : AppColors.joy.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isPrivate ? Icons.lock_outline : Icons.public,
                                      size: 16,
                                      color: _isPrivate ? AppColors.ink : AppColors.joy,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _isPrivate ? '私密' : '公开',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _isPrivate ? AppColors.ink : AppColors.joy,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            // 图片按钮
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.ink.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.image_outlined),
                                color: AppColors.ink,
                                iconSize: 20,
                                tooltip: '选择图片',
                              ),
                            ),
                          ],
                        ),

                        // 保存按钮
                        Container(
                          decoration: BoxDecoration(
                            gradient: _controller.text.trim().isEmpty
                                ? null
                                : LinearGradient(
                                    colors: [
                                      _getMoodColor(_selectedMood),
                                      _getMoodColor(_selectedMood).withValues(alpha: 0.8),
                                    ],
                                  ),
                            color: _controller.text.trim().isEmpty
                                ? AppColors.ink.withValues(alpha: 0.2)
                                : null,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: _controller.text.trim().isEmpty
                                ? []
                                : [
                                    BoxShadow(
                                      color: _getMoodColor(_selectedMood).withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: ElevatedButton(
                            onPressed: _controller.text.trim().isEmpty
                                ? null
                                : () {
                                    widget.onSave(
                                      _controller.text,
                                      _isPrivate,
                                      _imagePath,
                                      _selectedMood,
                                    );
                                    Navigator.of(context).pop();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '保存',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: _controller.text.trim().isEmpty
                                        ? AppColors.ink.withValues(alpha: 0.4)
                                        : Colors.white,
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodButton(Mood mood, String label, IconData icon) {
    final isSelected = _selectedMood == mood;
    final color = _getMoodColor(mood);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.ink.withValues(alpha: 0.4),
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? color : AppColors.ink.withValues(alpha: 0.6),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(Mood mood) {
    switch (mood) {
      case Mood.joy:
        return AppColors.joy;
      case Mood.calm:
        return AppColors.calm;
      case Mood.anxiety:
        return AppColors.anxiety;
      case Mood.sadness:
        return AppColors.sadness;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
