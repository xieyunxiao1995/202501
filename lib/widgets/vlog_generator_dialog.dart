import 'package:flutter/material.dart';
import '../models/log_model.dart';
import '../utils/constants.dart';

/// Dialog for generating Vlog or poster from camp logs
class VlogGeneratorDialog extends StatefulWidget {
  final List<LogEntry> logs;

  const VlogGeneratorDialog({super.key, required this.logs});

  @override
  State<VlogGeneratorDialog> createState() => _VlogGeneratorDialogState();
}

class _VlogGeneratorDialogState extends State<VlogGeneratorDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  String _selectedType = 'vlog';
  List<LogEntry> _selectedLogs = [];
  bool _isGenerating = false;

  final List<Map<String, dynamic>> _generationTypes = [
    {
      'id': 'vlog',
      'title': '露营Vlog',
      'description': '制作精美的视频回忆录',
      'icon': Icons.videocam,
      'color': AppConstants.accentColor,
    },
    {
      'id': 'poster',
      'title': '长图海报',
      'description': '生成适合分享的图片集',
      'icon': Icons.photo_library,
      'color': AppConstants.primaryColor,
    },
    {
      'id': 'story',
      'title': '故事集锦',
      'description': '文字版的露营故事',
      'icon': Icons.auto_stories,
      'color': Colors.purple,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedLogs = List.from(widget.logs);
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationDurationNormal,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _animationController.forward();
  }

  void _toggleLogSelection(LogEntry log) {
    setState(() {
      if (_selectedLogs.contains(log)) {
        _selectedLogs.remove(log);
      } else {
        _selectedLogs.add(log);
      }
    });
  }

  Future<void> _generateContent() async {
    if (_selectedLogs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请至少选择一条记录'),
          backgroundColor: AppConstants.accentColor,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    // Simulate generation process
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isGenerating = false;
    });

    Navigator.of(context).pop();
    
    final typeInfo = _generationTypes.firstWhere((t) => t['id'] == _selectedType);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${typeInfo['title']}生成完成！已保存到相册'),
        backgroundColor: AppConstants.primaryColor,
        action: SnackBarAction(
          label: '查看',
          textColor: Colors.white,
          onPressed: () {
            // Open generated content
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 700),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    Flexible(child: _buildContent()),
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacing8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppConstants.spacing12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 内容生成',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeHeading3,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '将你的露营记录制作成精美内容',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Generation Type Selection
          const Text(
            '选择生成类型',
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacing12),
          
          ..._generationTypes.map((type) {
            final isSelected = _selectedType == type['id'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = type['id'];
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: AppConstants.spacing8),
                padding: const EdgeInsets.all(AppConstants.spacing16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? type['color'].withValues(alpha: 0.1)
                      : AppConstants.secondaryColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: isSelected
                        ? type['color']
                        : Colors.grey.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacing8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? type['color']
                            : Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: Icon(
                        type['icon'],
                        color: isSelected ? Colors.white : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type['title'],
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? type['color'] : AppConstants.neutralColor,
                            ),
                          ),
                          Text(
                            type['description'],
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: type['color'],
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),
          
          const SizedBox(height: AppConstants.spacing24),
          
          // Log Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '选择记录',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_selectedLogs.length == widget.logs.length) {
                      _selectedLogs.clear();
                    } else {
                      _selectedLogs = List.from(widget.logs);
                    }
                  });
                },
                child: Text(
                  _selectedLogs.length == widget.logs.length ? '取消全选' : '全选',
                  style: const TextStyle(color: AppConstants.accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing12),
          
          ...widget.logs.map((log) {
            final isSelected = _selectedLogs.contains(log);
            return GestureDetector(
              onTap: () => _toggleLogSelection(log),
              child: Container(
                margin: const EdgeInsets.only(bottom: AppConstants.spacing8),
                padding: const EdgeInsets.all(AppConstants.spacing12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppConstants.primaryColor.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: isSelected
                        ? AppConstants.primaryColor
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isSelected ? AppConstants.primaryColor : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? AppConstants.primaryColor : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),
                    const SizedBox(width: AppConstants.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.location ?? '未知地点',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppConstants.primaryColor : AppConstants.neutralColor,
                            ),
                          ),
                          Text(
                            log.content.length > 50
                                ? '${log.content.substring(0, 50)}...'
                                : log.content,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${log.photoUrls.length}张照片',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeCaption,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      decoration: BoxDecoration(
        color: AppConstants.secondaryColor.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isGenerating ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
              ),
              child: const Text('取消'),
            ),
          ),
          const SizedBox(width: AppConstants.spacing12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isGenerating ? null : _generateContent,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
              ),
              child: _isGenerating
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('生成中...'),
                      ],
                    )
                  : const Text('开始生成'),
            ),
          ),
        ],
      ),
    );
  }
}