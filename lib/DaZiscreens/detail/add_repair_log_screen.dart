import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../DaZitheme/app_colors.dart';
import '../../DaZitheme/app_text_styles.dart';
import '../../DaZitheme/app_decorations.dart';
import '../../DaZimodels/repair_log.dart';
import '../../DaZiservices/storage_service.dart';
import '../../DaZiservices/repair_log_service.dart';
import '../../DaZiservices/image_service.dart';
import '../../DaZiutils/formatters.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 添加/编辑修复日志页面 - 深色霓虹风格
class AddRepairLogScreen extends StatefulWidget {
  final dynamic arguments;

  const AddRepairLogScreen({super.key, this.arguments});

  @override
  State<AddRepairLogScreen> createState() => _AddRepairLogScreenState();
}

class _AddRepairLogScreenState extends State<AddRepairLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _materialController = TextEditingController();
  final _toolController = TextEditingController();

  late RepairLogService _logService;
  late ImageService _imageService;

  String? _projectId;
  RepairLogEntry? _existingLog;
  DateTime _selectedDate = DateTime.now();
  List<String> _photoPaths = [];
  List<String> _materials = [];
  List<String> _tools = [];
  bool _isLoading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _initData();
    _initServices();
  }

  void _initData() {
    if (widget.arguments is Map) {
      final args = widget.arguments as Map;
      _projectId = args['projectId'] as String?;
      _existingLog = args['log'] as RepairLogEntry?;
    } else {
      _projectId = widget.arguments as String?;
    }

    if (_existingLog != null) {
      _isEdit = true;
      _titleController.text = _existingLog!.title;
      _descriptionController.text = _existingLog!.description;
      _notesController.text = _existingLog!.notes;
      _selectedDate = _existingLog!.date;
      _photoPaths = List.from(_existingLog!.photoPaths);
      _materials = List.from(_existingLog!.materials);
      _tools = List.from(_existingLog!.tools);
    }
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    _logService = RepairLogService(storageService: storageService);
    _imageService = ImageService();
  }

  Future<void> _pickImage() async {
    if (_photoPaths.length >= 3) {
      _showError('最多只能添加3张照片');
      return;
    }
    try {
      final file = await _imageService.pickFromGallery();
      if (file != null && mounted) {
        setState(() {
          _photoPaths.add(file.path);
        });
      }
    } catch (e) {
      _showError('选择照片失败: $e');
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photoPaths.removeAt(index);
    });
  }

  void _addMaterial() {
    if (_materialController.text.trim().isEmpty) return;
    setState(() {
      _materials.add(_materialController.text.trim());
      _materialController.clear();
    });
  }

  void _removeMaterial(int index) {
    setState(() {
      _materials.removeAt(index);
    });
  }

  void _addTool() {
    if (_toolController.text.trim().isEmpty) return;
    setState(() {
      _tools.add(_toolController.text.trim());
      _toolController.clear();
    });
  }

  void _removeTool(int index) {
    setState(() {
      _tools.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveLog() async {
    if (!_formKey.currentState!.validate()) return;
    if (_projectId == null) {
      _showError('项目ID无效');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final log = RepairLogEntry(
        id: _isEdit ? _existingLog!.id : const Uuid().v4(),
        projectId: _projectId!,
        date: _selectedDate,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        photoPaths: _photoPaths,
        materials: _materials,
        tools: _tools,
        notes: _notesController.text.trim(),
        createdAt: _isEdit ? _existingLog!.createdAt : DateTime.now(),
      );

      await _logService.addLog(log);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError('保存失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _materialController.dispose();
    _toolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final sectionSpacing = isSmallScreen ? 20.0 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          _isEdit ? '编辑日志' : '添加日志',
          style: AppTextStyles.headline3.copyWith(
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: AppColors.textPrimary,
            size: isSmallScreen ? 22 : 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 日期选择
                _buildSectionTitle('日期', isSmallScreen),
                SizedBox(height: isSmallScreen ? 6 : 8),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 14 : 16,
                      vertical: isSmallScreen ? 12 : 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 14 : 16,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                          size: isSmallScreen ? 18 : 20,
                        ),
                        SizedBox(width: isSmallScreen ? 10 : 12),
                        Text(
                          AppFormatters.formatDate(_selectedDate),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textLight,
                          size: isSmallScreen ? 18 : 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: sectionSpacing),

                // 标题
                _buildSectionTitle('标题', isSmallScreen),
                SizedBox(height: isSmallScreen ? 6 : 8),
                TextFormField(
                  controller: _titleController,
                  decoration: AppDecorations.inputDecoration(
                    hintText: '例如：清理裂痕、涂抹漆料',
                  ),
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入标题';
                    }
                    return null;
                  },
                ),
                SizedBox(height: sectionSpacing),

                // 描述
                _buildSectionTitle('描述', isSmallScreen),
                SizedBox(height: isSmallScreen ? 6 : 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: isSmallScreen ? 2 : 3,
                  decoration: AppDecorations.inputDecoration(
                    hintText: '描述本次修复的具体内容和进展...',
                  ),
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                ),
                SizedBox(height: sectionSpacing),

                // 照片
                _buildSectionTitle('照片', isSmallScreen),
                SizedBox(height: isSmallScreen ? 6 : 8),
                if (_photoPaths.isNotEmpty) ...[
                  SizedBox(
                    height: isSmallScreen ? 88 : 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          _photoPaths.length + (_photoPaths.length < 3 ? 1 : 0),
                      separatorBuilder: (_, __) =>
                          SizedBox(width: isSmallScreen ? 10 : 12),
                      itemBuilder: (context, index) {
                        if (index == _photoPaths.length) {
                          return _buildAddPhotoButton(isSmallScreen);
                        }
                        return _buildPhotoItem(index, isSmallScreen);
                      },
                    ),
                  ),
                ] else ...[
                  _buildAddPhotoButton(isSmallScreen),
                ],
                SizedBox(height: sectionSpacing),

                // 材料
                _buildSectionTitle('使用的材料', isSmallScreen),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _materialController,
                        decoration: AppDecorations.inputDecoration(
                          hintText: '添加材料',
                        ),
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                        onSubmitted: (_) => _addMaterial(),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 10 : 12),
                    GestureDetector(
                      onTap: _addMaterial,
                      child: Container(
                        width: isSmallScreen ? 44 : 48,
                        height: isSmallScreen ? 44 : 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.cyanGradient,
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 10 : 12,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: isSmallScreen ? 22 : 24,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_materials.isNotEmpty) ...[
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  Wrap(
                    spacing: isSmallScreen ? 6 : 8,
                    runSpacing: isSmallScreen ? 6 : 8,
                    children: _materials.asMap().entries.map((entry) {
                      return _buildRemovableTag(
                        entry.value,
                        AppColors.cyanGradient,
                        () => _removeMaterial(entry.key),
                        isSmallScreen,
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: sectionSpacing),

                // 工具
                _buildSectionTitle('使用的工具', isSmallScreen),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _toolController,
                        decoration: AppDecorations.inputDecoration(
                          hintText: '添加工具',
                        ),
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                        onSubmitted: (_) => _addTool(),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 10 : 12),
                    GestureDetector(
                      onTap: _addTool,
                      child: Container(
                        width: isSmallScreen ? 44 : 48,
                        height: isSmallScreen ? 44 : 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.purpleGradient,
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 10 : 12,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: isSmallScreen ? 22 : 24,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_tools.isNotEmpty) ...[
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  Wrap(
                    spacing: isSmallScreen ? 6 : 8,
                    runSpacing: isSmallScreen ? 6 : 8,
                    children: _tools.asMap().entries.map((entry) {
                      return _buildRemovableTag(
                        entry.value,
                        AppColors.purpleGradient,
                        () => _removeTool(entry.key),
                        isSmallScreen,
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: sectionSpacing),

                // 笔记
                _buildSectionTitle('笔记', isSmallScreen),
                SizedBox(height: isSmallScreen ? 6 : 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: isSmallScreen ? 3 : 4,
                  decoration: AppDecorations.inputDecoration(
                    hintText: '记录任何需要记住的事项、心得或下次注意事项...',
                  ),
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                ),
                SizedBox(height: isSmallScreen ? 32 : 40),

                // 保存按钮
                GestureDetector(
                  onTap: _isLoading ? null : _saveLog,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 14 : 16,
                    ),
                    decoration: AppDecorations.primaryButton(
                      isDisabled: _isLoading,
                    ),
                    child: Center(
                      child: _isLoading
                          ? SizedBox(
                              width: isSmallScreen ? 18 : 20,
                              height: isSmallScreen ? 18 : 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isEdit ? '保存修改' : '添加日志',
                              style: AppTextStyles.button.copyWith(
                                fontSize: isSmallScreen ? 15 : 16,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isSmallScreen) {
    return Text(
      title,
      style: AppTextStyles.labelLarge.copyWith(
        color: AppColors.textPrimary,
        fontSize: isSmallScreen ? 15 : 16,
      ),
    );
  }

  Widget _buildAddPhotoButton(bool isSmallScreen) {
    final size = isSmallScreen ? 88.0 : 100.0;
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
          border: Border.all(color: AppColors.primary.withAlpha(77), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: AppColors.primary,
              size: isSmallScreen ? 28 : 32,
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              '添加照片',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: isSmallScreen ? 11 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoItem(int index, bool isSmallScreen) {
    final size = isSmallScreen ? 88.0 : 100.0;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
          child: Image.file(
            File(_photoPaths[index]),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: size,
                height: size,
                color: AppColors.surfaceLight,
                child: Icon(
                  Icons.image_not_supported,
                  color: AppColors.textLight,
                  size: isSmallScreen ? 22 : 24,
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
              width: isSmallScreen ? 22 : 24,
              height: isSmallScreen ? 22 : 24,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemovableTag(
    String text,
    LinearGradient gradient,
    VoidCallback onRemove,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 12,
        vertical: isSmallScreen ? 5 : 6,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 10 : 11,
            ),
          ),
          SizedBox(width: isSmallScreen ? 4 : 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: isSmallScreen ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
