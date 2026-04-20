import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/data.dart';
import '../theme/theme.dart';
import '../components/mood_selector.dart';
import '../components/weather_selector.dart';
import '../components/ootd_toggle.dart';
import '../components/image_gallery.dart';
import '../components/tag_input.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  MoodType _selectedMood = MoodType.happy;
  String _selectedWeather = 'wb_sunny';
  List<String> _selectedImages = [];
  List<String> _tags = [];
  bool _isOotd = false;
  bool _isLoading = false;

  DateTime _selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _moodOptions = [
    {'type': MoodType.happy, 'icon': '😊', 'label': '开心'},
    {'type': MoodType.chill, 'icon': '😌', 'label': '放松'},
    {'type': MoodType.excited, 'icon': '🎉', 'label': '兴奋'},
    {'type': MoodType.sad, 'icon': '😢', 'label': '难过'},
  ];

  final List<Map<String, String>> _weatherOptions = [
    {'icon': 'wb_sunny', 'label': '晴天'},
    {'icon': 'cloud', 'label': '多云'},
    {'icon': 'rainy', 'label': '雨天'},
    {'icon': 'nightlight', 'label': '夜晚'},
  ];

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textMain,
              surface: AppColors.surfaceLight,
              onSurface: AppColors.textMain,
            ),
            dialogBackgroundColor: AppColors.backgroundLight,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addSuggestedTag(String tag) {
    if (!_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
      });
    }
  }

  Future<void> _saveEntry() async {
    if (_contentController.text.trim().isEmpty && _selectedImages.isEmpty) {
      _showSnackBar('请添加内容或图片');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final isToday =
        _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
    final isYesterday =
        _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day - 1;

    String dateLabel;
    if (isToday) {
      dateLabel = '今天';
    } else if (isYesterday) {
      dateLabel = '昨天';
    } else {
      dateLabel = DateFormat('MM月d日 EEE').format(_selectedDate);
    }

    final newItem = TimelineItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dateLabel: dateLabel,
      timeLabel: _formatTime(_selectedDate),
      timestamp: _selectedDate,
      mood: Mood(
        icon:
            _moodOptions.firstWhere((m) => m['type'] == _selectedMood)['icon']
                as String,
        label: _getMoodLabel(_selectedMood),
        type: _selectedMood,
      ),
      weather: Weather(
        icon: _selectedWeather,
        label: _getWeatherLabel(_selectedWeather),
      ),
      content: _contentController.text.trim(),
      images: _selectedImages,
      tags: _tags,
      isOotd: _isOotd,
    );

    await AppState.instance.addTimelineItem(newItem);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pop(true);
      _showSnackBar('记录保存成功！✨');
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute';
  }

  String _getMoodLabel(MoodType type) {
    switch (type) {
      case MoodType.happy:
        return '心情开心';
      case MoodType.chill:
        return '心情放松';
      case MoodType.excited:
        return '心情兴奋';
      case MoodType.sad:
        return '心情难过';
    }
  }

  String _getWeatherLabel(String icon) {
    switch (icon) {
      case 'wb_sunny':
        return '晴天';
      case 'cloud':
        return '多云';
      case 'rainy':
        return '雨天';
      case 'nightlight':
        return '晴朗夜晚';
      default:
        return '晴天';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF1A3A34)),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: const Text(
          '新记录',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3A34),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveEntry,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryDark,
                      ),
                    ),
                  )
                : const Text(
                    '保存',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(title: '日期', child: _buildDateSelector()),

            _buildSection(
              title: '你今天感觉如何？',
              child: MoodSelector(
                selectedMood: _selectedMood,
                onMoodSelected: (mood) => setState(() => _selectedMood = mood),
              ),
            ),

            _buildSection(
              title: '天气',
              child: WeatherSelector(
                selectedWeather: _selectedWeather,
                onWeatherSelected: (weather) =>
                    setState(() => _selectedWeather = weather),
              ),
            ),

            _buildSection(
              title: '今日穿搭',
              child: OotdToggle(
                isOotd: _isOotd,
                onOotdChanged: (value) => setState(() => _isOotd = value),
              ),
            ),

            _buildSection(title: '你的想法', child: _buildContentInput()),

            _buildSection(
              title: '照片',
              child: ImageGallery(
                images: _selectedImages,
                onImagesChanged: (images) =>
                    setState(() => _selectedImages = images),
                maxImages: 4,
              ),
            ),

            _buildSection(
              title: '标签',
              child: TagInput(
                tags: _tags,
                onTagsChanged: (tags) => setState(() => _tags = tags),
                suggestions: commonTags,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600, // 修复了 fontWeight 的类型
              color: Colors.grey.shade600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.primaryDark,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '已选日期',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('yyyy年MM月d日 EEEE').format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A3A34),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _contentController,
        maxLines: 5,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textMain,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: '记录你的一天、想法或感受...',
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundLight.withOpacity(0),
            AppColors.backgroundLight.withOpacity(1),
          ],
        ),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: _isLoading ? null : _saveEntry,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textMain,
                      ),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: AppColors.textMain,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '保存记录',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
