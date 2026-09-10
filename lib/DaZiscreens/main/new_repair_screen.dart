import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../models/repair_project.dart';
import '../../services/storage_service.dart';
import '../../services/project_service.dart';
import '../../services/image_service.dart';
import '../../services/ai_service.dart';
import '../../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewRepairScreen extends StatefulWidget {
  const NewRepairScreen({super.key});

  @override
  State<NewRepairScreen> createState() => _NewRepairScreenState();
}

class _NewRepairScreenState extends State<NewRepairScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late ProjectService _projectService;
  late ImageService _imageService;
  late AIService _aiService;

  String? _selectedDamageType = 'crack';
  String? _selectedMaterial = 'stoneware';
  String? _selectedAesthetic = 'classic-gold';
  String? _photoPath;
  bool _isLoading = false;
  bool _isGeneratingNarrative = false;
  String? _generatedNarrative;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    _projectService = ProjectService(storageService: storageService);
    _imageService = ImageService();
    _aiService = AIService();
  }

  Future<void> _pickFromGallery() async {
    try {
      final file = await _imageService.pickFromGallery();
      if (file != null && mounted) {
        setState(() {
          _photoPath = file.path;
        });
      }
    } catch (e) {
      _showError('Failed to pick photo: $e');
    }
  }

  Future<void> _generateNarrative() async {
    if (_descriptionController.text.isEmpty) {
      _showError('请先描述损坏情况');
      return;
    }

    setState(() {
      _isGeneratingNarrative = true;
    });

    try {
      final narrative = await _aiService.generateCrackNarrative(
        damageType: _selectedDamageType ?? 'crack',
        material: _selectedMaterial ?? 'stoneware',
        aesthetic: _selectedAesthetic ?? 'classic-gold',
        description: _descriptionController.text,
      );

      if (mounted) {
        setState(() {
          _generatedNarrative = narrative;
          _isGeneratingNarrative = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGeneratingNarrative = false;
        });
        _showError('Failed to generate narrative: $e');
      }
    }
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final project = RepairProject(
        id: const Uuid().v4(),
        title: _titleController.text.isNotEmpty
            ? _titleController.text
            : 'Repair ${DateTime.now().day}/${DateTime.now().month}',
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        photoPaths: _photoPath != null ? [_photoPath!] : [],
        damageType: _selectedDamageType ?? 'crack',
        material: _selectedMaterial ?? 'stoneware',
        aesthetic: _selectedAesthetic ?? 'classic-gold',
        crackNarrative: _generatedNarrative ?? '',
        techniqueProgress: 0,
        aiRecommendations: [],
        isArchived: false,
      );

      await _projectService.createProject(project);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSuccess('项目保存成功');
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showError('保存项目失败: $e');
      }
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _photoPath = null;
      _selectedDamageType = 'crack';
      _selectedMaterial = 'stoneware';
      _selectedAesthetic = 'classic-gold';
      _generatedNarrative = null;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final sectionSpacing = isSmallScreen ? 20.0 : 28.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: isSmallScreen ? 44 : 48,
                        height: isSmallScreen ? 44 : 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.pinkGradient,
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 14 : 16,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(77),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.add_photo_alternate,
                          color: Colors.white,
                          size: isSmallScreen ? 22 : 24,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      Text(
                        '新建修复',
                        style: AppTextStyles.headline1.copyWith(
                          fontSize: isSmallScreen ? 24 : 28,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sectionSpacing),
                  // Photo Section
                  Text('照片', style: AppTextStyles.labelLarge),
                  SizedBox(height: isSmallScreen ? 10 : 12),
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(),
                    child: Container(
                      height: isSmallScreen ? 160 : 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: _photoPath == null
                            ? AppColors.pinkGradient
                            : null,
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 20 : 24,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(51),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: _photoPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 20 : 24,
                              ),
                              child: Image.file(
                                File(_photoPath!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: isSmallScreen ? 56 : 64,
                                  height: isSmallScreen ? 56 : 64,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(51),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: isSmallScreen ? 28 : 32,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 10 : 12),
                                Text(
                                  '点击添加照片',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: isSmallScreen ? 13 : 14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: sectionSpacing),

                  // Title
                  Text('标题（可选）', style: AppTextStyles.labelLarge),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: AppDecorations.inputDecoration(
                      hintText: '为您的项目命名',
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Description
                  Text('描述', style: AppTextStyles.labelLarge),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: isSmallScreen ? 2 : 3,
                    decoration: AppDecorations.inputDecoration(
                      hintText: '描述损坏情况和修复目标',
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Damage Type
                  Text('损坏类型', style: AppTextStyles.labelLarge),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Wrap(
                    spacing: isSmallScreen ? 6 : 8,
                    runSpacing: isSmallScreen ? 6 : 8,
                    children: AppConstants.damageTypes.map((type) {
                      final isSelected = _selectedDamageType == type;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDamageType = type;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 8 : 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentGold.withAlpha(26)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 16 : 20,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentGold
                                  : AppColors.surfaceLight,
                            ),
                          ),
                          child: Text(
                            AppConstants.getDamageTypeLabel(type),
                            style: AppTextStyles.labelMedium.copyWith(
                              fontSize: isSmallScreen ? 12 : 13,
                              color: isSelected
                                  ? AppColors.accentGold
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Material
                  Text('陶瓷材质', style: AppTextStyles.labelLarge),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Wrap(
                    spacing: isSmallScreen ? 6 : 8,
                    runSpacing: isSmallScreen ? 6 : 8,
                    children: AppConstants.materials.map((material) {
                      final isSelected = _selectedMaterial == material;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMaterial = material;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 8 : 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryLight.withAlpha(51)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 16 : 20,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceLight,
                            ),
                          ),
                          child: Text(
                            AppConstants.getMaterialLabel(material),
                            style: AppTextStyles.labelMedium.copyWith(
                              fontSize: isSmallScreen ? 12 : 13,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Aesthetic
                  Text('美学偏好', style: AppTextStyles.labelLarge),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Wrap(
                    spacing: isSmallScreen ? 6 : 8,
                    runSpacing: isSmallScreen ? 6 : 8,
                    children: AppConstants.aesthetics.map((aesthetic) {
                      final isSelected = _selectedAesthetic == aesthetic;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAesthetic = aesthetic;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 8 : 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentGold.withAlpha(26)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 16 : 20,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentGold
                                  : AppColors.surfaceLight,
                            ),
                          ),
                          child: Text(
                            AppConstants.getAestheticLabel(aesthetic),
                            style: AppTextStyles.labelMedium.copyWith(
                              fontSize: isSmallScreen ? 12 : 13,
                              color: isSelected
                                  ? AppColors.accentGold
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 24),

                  // Generate Narrative Button
                  GestureDetector(
                    onTap: _isGeneratingNarrative ? null : _generateNarrative,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 12 : 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 10 : 12,
                        ),
                        border: Border.all(
                          color: AppColors.accentGold.withAlpha(77),
                        ),
                      ),
                      child: Center(
                        child: _isGeneratingNarrative
                            ? SizedBox(
                                width: isSmallScreen ? 18 : 20,
                                height: isSmallScreen ? 18 : 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.accentGold,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: AppColors.accentGold,
                                    size: isSmallScreen ? 18 : 20,
                                  ),
                                  SizedBox(width: isSmallScreen ? 6 : 8),
                                  Text(
                                    '生成裂痕故事',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: AppColors.accentGold,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  // Generated Narrative
                  if (_generatedNarrative != null) ...[
                    SizedBox(height: isSmallScreen ? 14 : 16),
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 10 : 12,
                        ),
                        border: Border.all(
                          color: AppColors.accentGold.withAlpha(77),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '裂痕叙事',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.accentGold,
                              fontSize: isSmallScreen ? 12 : 13,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 6 : 8),
                          Text(
                            _generatedNarrative!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontStyle: FontStyle.italic,
                              fontSize: isSmallScreen ? 13 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Save Button
                  GestureDetector(
                    onTap: _isLoading ? null : _saveProject,
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
                                '保存项目',
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
      ),
    );
  }

  void _showImageSourceDialog() {
    _pickFromGallery();
  }
}
