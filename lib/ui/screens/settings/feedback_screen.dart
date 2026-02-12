import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contactController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入反馈内容')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _contentController.clear();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.bgPaper,
          title: Text('提交成功', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack)),
          content: Text('感谢您的反馈！我们会尽快查看并处理。', style: GoogleFonts.notoSerifSc(color: AppColors.inkBlack)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('确定', style: GoogleFonts.maShanZheng(color: AppColors.inkRed)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 380;

    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.inkBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('反馈与建议', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: isSmallScreen ? 24 : 28)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '如果您在游戏中遇到任何问题，或有任何建议，欢迎告诉我们。',
              style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 14 : 16, color: AppColors.inkBlack.withOpacity(0.8), height: 1.5),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            _buildLabel('联系方式 (选填)', isSmallScreen),
            SizedBox(height: isSmallScreen ? 6 : 8),
            _buildTextField(
              controller: _contactController,
              hintText: 'QQ / 微信 / 邮箱',
              maxLines: 1,
              isSmallScreen: isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildLabel('反馈内容', isSmallScreen),
            SizedBox(height: isSmallScreen ? 6 : 8),
            _buildTextField(
              controller: _contentController,
              hintText: '请详细描述您遇到的问题或建议...',
              maxLines: 8,
              isSmallScreen: isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 32 : 48),
            SizedBox(
              width: double.infinity,
              height: isSmallScreen ? 44 : 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.inkBlack,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: isSmallScreen ? 20 : 24,
                        height: isSmallScreen ? 20 : 24,
                        child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        '提交反馈',
                        style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 18 : 20),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isSmallScreen) {
    return Text(
      text,
      style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 16 : 18, color: AppColors.inkBlack),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
    required bool isSmallScreen,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.woodDark.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 14 : 16, color: AppColors.inkBlack),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.notoSerifSc(color: Colors.grey, fontSize: isSmallScreen ? 14 : 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        ),
      ),
    );
  }
}
