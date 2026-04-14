import 'package:flutter/material.dart';

/// 反馈与建议页面
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String _selectedType = '功能建议';
  final List<String> _feedbackTypes = ['功能建议', 'Bug反馈', '体验优化', '其他问题'];

  int _rating = 5;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('反馈与建议'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00F0FF),
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00F0FF)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部提示
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF00F0FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF00F0FF).withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Text('💬', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '您的每一条建议都是我们进步的动力！我们会认真阅读并不断优化游戏体验。',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFAABBCC),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 评分
            _buildSectionTitle('🌟 游戏评分'),
            const SizedBox(height: 8),
            _buildRatingSection(),
            const SizedBox(height: 20),

            // 反馈类型
            _buildSectionTitle('📂 反馈类型'),
            const SizedBox(height: 8),
            _buildFeedbackTypeSelector(),
            const SizedBox(height: 20),

            // 反馈内容
            _buildSectionTitle('📝 详细描述'),
            const SizedBox(height: 8),
            _buildFeedbackInput(),
            const SizedBox(height: 20),

            // 联系方式（选填）
            _buildSectionTitle('📧 联系方式（选填）'),
            const SizedBox(height: 8),
            _buildContactInput(),
            const SizedBox(height: 10),
            const Text(
              '填写邮箱或社交账号，方便我们回复您的反馈',
              style: TextStyle(fontSize: 11, color: Color(0xFF667788)),
            ),
            const SizedBox(height: 30),

            // 提交按钮
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00F0FF),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A2240)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _rating = index + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 36,
                    color: index < _rating
                        ? const Color(0xFFFFEA00)
                        : const Color(0xFF334455),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            ['非常不满意', '不满意', '一般', '满意', '非常满意'][_rating - 1],
            style: TextStyle(
              fontSize: 13,
              color: _rating >= 4
                  ? const Color(0xFF00FF88)
                  : _rating >= 3
                  ? const Color(0xFFFFEA00)
                  : const Color(0xFFFF003C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A2240)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _feedbackTypes.map((type) {
          final isSelected = _selectedType == type;
          return GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00F0FF).withOpacity(0.2)
                    : const Color(0xFF060A12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00F0FF)
                      : const Color(0xFF1A2240),
                ),
              ),
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected
                      ? const Color(0xFF00F0FF)
                      : const Color(0xFF8899AA),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeedbackInput() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A2240)),
      ),
      child: TextField(
        controller: _feedbackController,
        maxLines: 6,
        style: const TextStyle(fontSize: 14, color: Colors.white),
        decoration: const InputDecoration(
          hintText: '请详细描述您的反馈或建议...\n例如：我觉得可以增加一个新的功能...',
          hintStyle: TextStyle(color: Color(0xFF445566), fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildContactInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A2240)),
      ),
      child: TextField(
        controller: _contactController,
        style: const TextStyle(fontSize: 14, color: Colors.white),
        decoration: const InputDecoration(
          hintText: '请输入邮箱或社交账号',
          hintStyle: TextStyle(color: Color(0xFF445566), fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00F0FF),
          foregroundColor: const Color(0xFF030408),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF030408)),
                ),
              )
            : const Text(
                '提交反馈',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _submitFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请填写反馈内容'),
          backgroundColor: Color(0xFFFF003C),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // 模拟提交
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('感谢您的反馈！我们会认真处理您的建议 🙏'),
          backgroundColor: const Color(0xFF00FF88),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      // 清空输入
      _feedbackController.clear();
      _contactController.clear();
    });
  }
}
