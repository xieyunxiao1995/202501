import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import '../models/log_model.dart';
import '../utils/constants.dart';
import '../services/data_service.dart';

/// Dialog for creating new camp log entries
class CreateLogDialog extends StatefulWidget {
  final Function(LogEntry) onLogCreated;

  const CreateLogDialog({super.key, required this.onLogCreated});

  @override
  State<CreateLogDialog> createState() => _CreateLogDialogState();
}

class _CreateLogDialogState extends State<CreateLogDialog> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _contentController = TextEditingController();
  final _dataService = DataService();
  final _imagePicker = ImagePicker();
  
  String? _selectedMood;
  String? _selectedWeather;
  final List<XFile> _selectedImages = [];
  bool _isPickingImage = false;
  
  static const int _maxImageCount = 5;

  final List<Map<String, String>> _moods = [
    {'value': Mood.happy, 'label': '开心', 'emoji': '😊'},
    {'value': Mood.excited, 'label': '兴奋', 'emoji': '🤩'},
    {'value': Mood.peaceful, 'label': '平静', 'emoji': '😌'},
    {'value': Mood.tired, 'label': '疲惫', 'emoji': '😴'},
    {'value': Mood.adventurous, 'label': '冒险', 'emoji': '🤠'},
  ];

  final List<Map<String, String>> _weathers = [
    {'value': 'sunny', 'label': '晴天', 'emoji': '☀️'},
    {'value': 'cloudy', 'label': '多云', 'emoji': '☁️'},
    {'value': 'rainy', 'label': '雨天', 'emoji': '🌧️'},
    {'value': 'snowy', 'label': '雪天', 'emoji': '❄️'},
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_isPickingImage) return;
    
    // Check if we've reached the maximum number of images
    if (_selectedImages.length >= _maxImageCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('最多只能添加 $_maxImageCount 张照片'),
          backgroundColor: AppConstants.accentColor,
        ),
      );
      return;
    }
    
    setState(() {
      _isPickingImage = true;
    });

    try {
      // Show options for camera or gallery
      final source = await _showImageSourceDialog();
      if (source == null) {
        setState(() {
          _isPickingImage = false;
        });
        return;
      }

      if (source == ImageSource.gallery) {
        // Calculate how many more images we can add
        final remainingSlots = _maxImageCount - _selectedImages.length;
        
        if (remainingSlots <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已达到最大照片数量限制（$_maxImageCount张）'),
              backgroundColor: AppConstants.accentColor,
            ),
          );
          return;
        }
        
        // For gallery selection, we'll pick one by one to respect the limit
        // This ensures we don't exceed the limit even if user selects many
        if (remainingSlots == 1) {
          // If only one slot remaining, use single image picker
          final XFile? image = await _imagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 1920,
            maxHeight: 1920,
            imageQuality: 85,
          );
          
          if (image != null) {
            final croppedImage = await _cropImage(image);
            if (croppedImage != null) {
              setState(() {
                _selectedImages.add(croppedImage);
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('照片已添加'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          }
        } else {
          // Multiple slots available, but limit the selection
          final List<XFile> images = await _imagePicker.pickMultiImage(
            maxWidth: 1920,
            maxHeight: 1920,
            imageQuality: 85,
          );
          
          if (images.isNotEmpty) {
            // Strictly limit to remaining slots
            final imagesToAdd = images.take(remainingSlots).toList();
            int successCount = 0;
            
            // Process each image with cropping
            for (final image in imagesToAdd) {
              // Check again in case we're at the limit
              if (_selectedImages.length >= _maxImageCount) break;
              
              final croppedImage = await _cropImage(image);
              if (croppedImage != null) {
                setState(() {
                  _selectedImages.add(croppedImage);
                });
                successCount++;
              }
            }
            
            final skippedCount = images.length - imagesToAdd.length;
            
            String message = '已添加 $successCount 张照片';
            if (skippedCount > 0) {
              message += '，跳过 $skippedCount 张（超出限制）';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        // Take photo with camera
        if (_selectedImages.length >= _maxImageCount) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已达到最大照片数量限制（$_maxImageCount张）'),
              backgroundColor: AppConstants.accentColor,
            ),
          );
          return;
        }
        
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
        
        if (image != null) {
          final croppedImage = await _cropImage(image);
          if (croppedImage != null) {
            setState(() {
              _selectedImages.add(croppedImage);
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('照片已添加'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('选择照片失败: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  Future<XFile?> _cropImage(XFile imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9), // 16:9 aspect ratio for better display
        uiSettings: [
          IOSUiSettings(
            title: '裁剪照片',
            doneButtonTitle: '完成',
            cancelButtonTitle: '取消',
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: true,
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
            hidesNavigationBar: false,
            rectX: 0,
            rectY: 0,
            rectWidth: 0,
            rectHeight: 0,
            showActivitySheetOnDone: false,
          ),
          AndroidUiSettings(
            toolbarTitle: '裁剪照片',
            toolbarColor: AppConstants.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedFile != null) {
        return XFile(croppedFile.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('裁剪照片失败: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('选择照片来源'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('从相册选择'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('拍照'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _createLog() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Convert XFile paths to strings for storage
        final photoUrls = _selectedImages.map((image) => image.path).toList();
        
        final newLog = LogEntry(
          id: 'log_${DateTime.now().millisecondsSinceEpoch}',
          date: DateTime.now(),
          location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
          photoUrls: photoUrls,
          content: _contentController.text.trim(),
          mood: _selectedMood,
          weather: _selectedWeather,
          isPublished: false,
        );

        // Add to data service
        await _dataService.addLogEntry(newLog);
        widget.onLogCreated(newLog);
        
        if (mounted) {
          Navigator.of(context).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('露营记录已保存！'),
              backgroundColor: AppConstants.primaryColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存记录失败，请重试'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白区域收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 700),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8F9FF), Color(0xFFE8F4FD), Color(0xFFF0F8FF)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '记录这次露营',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '分享你的美好时光',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location
                        _buildInputSection(
                          '地点',
                          Icons.location_on,
                          TextFormField(
                            controller: _locationController,
                            maxLength: 50, // 限制地点名称长度
                            decoration: InputDecoration(
                              hintText: '这次露营在哪里？',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF667EEA),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.9),
                              contentPadding: const EdgeInsets.all(16),
                              counterText: '', // 隐藏字符计数器
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Photos
                        _buildSectionTitle('照片', Icons.photo_camera),
                        const SizedBox(height: 16),
                        
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                          child: SizedBox(
                            height: 80,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                // Add photo button (only show if under limit)
                                if (_selectedImages.length < _maxImageCount)
                                  GestureDetector(
                                    onTap: _isPickingImage ? null : _pickImages,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF667EEA).withValues(alpha: 0.1),
                                            const Color(0xFF764BA2).withValues(alpha: 0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: _isPickingImage
                                          ? const Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '选择中',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF667EEA),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.add_a_photo,
                                                  color: Color(0xFF667EEA),
                                                  size: 24,
                                                ),
                                                const SizedBox(height: 4),
                                                const Text(
                                                  '添加照片',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF667EEA),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '${_selectedImages.length}/$_maxImageCount',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                
                                // Photo thumbnails
                                ..._selectedImages.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final image = entry.value;
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    margin: const EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.file(
                                            File(image.path),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: const Icon(
                                                  Icons.error,
                                                  color: Colors.grey,
                                                  size: 32,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () => _removePhoto(index),
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [Colors.red[400]!, Colors.red[600]!],
                                                ),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.red.withValues(alpha: 0.3),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Content
                        _buildInputSection(
                          '记录内容',
                          Icons.edit_note,
                          TextFormField(
                            controller: _contentController,
                            maxLines: 4,
                            maxLength: 500, // 限制内容长度
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '请分享一下这次露营的感受';
                              }
                              if (value.trim().length < 10) {
                                return '内容至少需要10个字符';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: '分享这次露营的美好时光...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF667EEA),
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.red[400]!,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.9),
                              contentPadding: const EdgeInsets.all(16),
                              alignLabelWithHint: true,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Mood and Weather
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Mood
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.mood,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        '心情',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1D29),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _moods.map((mood) {
                                      final isSelected = _selectedMood == mood['value'];
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedMood = isSelected ? null : mood['value'];
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: isSelected
                                                ? const LinearGradient(
                                                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                                  )
                                                : null,
                                            color: isSelected ? null : Colors.grey[100],
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.transparent
                                                  : Colors.grey.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(mood['emoji']!, style: const TextStyle(fontSize: 16)),
                                              const SizedBox(width: 6),
                                              Text(
                                                mood['label']!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected ? Colors.white : const Color(0xFF1A1D29),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Weather
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.wb_sunny,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        '天气',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1D29),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _weathers.map((weather) {
                                      final isSelected = _selectedWeather == weather['value'];
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedWeather = isSelected ? null : weather['value'];
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: isSelected
                                                ? const LinearGradient(
                                                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                                  )
                                                : null,
                                            color: isSelected ? null : Colors.grey[100],
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.transparent
                                                  : Colors.grey.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(weather['emoji']!, style: const TextStyle(fontSize: 16)),
                                              const SizedBox(width: 6),
                                              Text(
                                                weather['label']!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected ? Colors.white : const Color(0xFF1A1D29),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
              // Actions
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          '取消',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1D29),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _createLog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            '保存记录',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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
    );
  }

  Widget _buildInputSection(String title, IconData icon, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D29),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1D29),
          ),
        ),
      ],
    );
  }
}