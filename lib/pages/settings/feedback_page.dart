import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/dual_glow_background.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _feedbackType = '功能建议';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '反馈与建议',
          style: TextStyle(color: AppColors.ink),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: DualGlowBackground(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Transform.rotate(
                  angle: 0.01,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardFace,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '我们期待您的声音',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '您的反馈将帮助我们做得更好',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.inkLight,
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            // 反馈类型
                            const Text(
                              '反馈类型',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              children: ['功能建议', '问题反馈', '使用体验', '其他'].map((type) {
                                final isSelected = _feedbackType == type;
                                return ChoiceChip(
                                  label: Text(type),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => _feedbackType = type);
                                    }
                                  },
                                  backgroundColor: Colors.transparent,
                                  selectedColor: AppColors.ink.withValues(alpha: 0.1),
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppColors.ink : AppColors.inkLight,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  side: BorderSide(
                                    color: isSelected 
                                        ? AppColors.ink 
                                        : AppColors.ink.withValues(alpha: 0.2),
                                  ),
                                );
                              }).toList(),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // 标题
                            const Text(
                              '标题',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: '简要描述您的反馈',
                                hintStyle: TextStyle(color: AppColors.inkLight.withValues(alpha: 0.5)),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: AppColors.ink.withValues(alpha: 0.2)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: AppColors.ink.withValues(alpha: 0.2)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.ink),
                                ),
                              ),
                              style: const TextStyle(color: AppColors.ink),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '请输入标题';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // 详细内容
                            const Text(
                              '详细内容',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _contentController,
                              maxLines: 8,
                              decoration: InputDecoration(
                                hintText: '请详细描述您的想法或遇到的问题...',
                                hintStyle: TextStyle(color: AppColors.inkLight.withValues(alpha: 0.5)),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: AppColors.ink.withValues(alpha: 0.2)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: AppColors.ink.withValues(alpha: 0.2)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.ink),
                                ),
                              ),
                              style: const TextStyle(color: AppColors.ink),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '请输入详细内容';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // 提交按钮
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _submitFeedback,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.ink,
                                  foregroundColor: AppColors.cardFace,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  '提交反馈',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // 联系方式提示
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.ink.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.info_outline, color: AppColors.ink, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        '其他联系方式',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '您也可以通过以下方式联系我们：\n'
                                    '• 邮箱：feedback@mindflow.app\n'
                                    '• 微信公众号：心屿MindFlow',
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.6,
                                      color: AppColors.ink.withValues(alpha: 0.7),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // 这里可以添加实际的反馈提交逻辑
      // 目前只是显示成功提示
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardFace,
          title: const Text(
            '感谢您的反馈',
            style: TextStyle(color: AppColors.ink),
          ),
          content: const Text(
            '您的反馈已记录，我们会认真考虑您的建议！',
            style: TextStyle(color: AppColors.ink),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
      
      // 清空表单
      _titleController.clear();
      _contentController.clear();
      setState(() => _feedbackType = '功能建议');
    }
  }
}
