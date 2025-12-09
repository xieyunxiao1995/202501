import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();
  String _selectedType = 'Bug Report';
  int _selectedRating = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.3, 0.6, 1.0],
              colors: [
                Color(0xFFF8FAFF),
                Color(0xFFEDF4FF),
                Color(0xFFE8F2FF),
                Color(0xFFF0F8FF),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppConstants.spacing20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildHeaderCard(),
                          const SizedBox(height: AppConstants.spacing20),
                          _buildQuickFeedbackCard(),
                          const SizedBox(height: AppConstants.spacing20),
                          _buildFormCard(),
                          const SizedBox(height: AppConstants.spacing20),
                          _buildOtherContactCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing16,
        vertical: AppConstants.spacing12,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppConstants.primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            '反馈',
            style: TextStyle(
              fontSize: AppConstants.fontSizeHeading3,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00BCD4),
            const Color(0xFF00BCD4).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.feedback, size: 56, color: Colors.white),
          const SizedBox(height: AppConstants.spacing16),
          const Text(
            '我们重视您的反馈',
            style: TextStyle(
              fontSize: AppConstants.fontSizeHeading2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacing12),
          Text(
            '您的想法帮助我们改进 约傍。分享您的想法、报告问题，或者让我们知道我们做得如何！',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.white.withValues(alpha: 0.95),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFeedbackCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.star,
                  color: Color(0xFFFF9800),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '评价您的体验',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing20),
          const Text(
            '您如何评价您在 约傍 的整体体验？',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.neutralColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedRating = index + 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    _selectedRating > index ? Icons.star : Icons.star_border,
                    size: 40,
                    color: const Color(0xFFFF9800),
                  ),
                ),
              );
            }),
          ),
          if (_selectedRating > 0) ...[
            const SizedBox(height: AppConstants.spacing12),
            Center(
              child: Text(
                _getRatingText(_selectedRating),
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return '差 - 我们可以做得更好';
      case 2:
        return '一般 - 需要改进';
      case 3:
        return '好 - 符合期望';
      case 4:
        return '很好 - 超出期望';
      case 5:
        return '优秀 - 非常喜欢！';
      default:
        return '';
    }
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Color(0xFF4A90E2),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '详细反馈',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing24),
          const Text(
            '反馈类型',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: AppConstants.neutralColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              filled: true,
              fillColor: AppConstants.secondaryColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing16,
                vertical: AppConstants.spacing12,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Bug Report',
                child: Row(
                  children: [
                    Icon(Icons.bug_report, size: 20, color: Color(0xFFF44336)),
                    SizedBox(width: 12),
                    Text('错误报告'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'Feature Request',
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, size: 20, color: Color(0xFFFF9800)),
                    SizedBox(width: 12),
                    Text('功能请求'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'General Feedback',
                child: Row(
                  children: [
                    Icon(Icons.chat, size: 20, color: Color(0xFF4A90E2)),
                    SizedBox(width: 12),
                    Text('一般反馈'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'Suggestion',
                child: Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates,
                      size: 20,
                      color: Color(0xFF66BB6A),
                    ),
                    SizedBox(width: 12),
                    Text('建议'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'Complaint',
                child: Row(
                  children: [
                    Icon(
                      Icons.report_problem,
                      size: 20,
                      color: Color(0xFF9C27B0),
                    ),
                    SizedBox(width: 12),
                    Text('投诉'),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedType = value!);
            },
          ),
          const SizedBox(height: AppConstants.spacing20),
          const Text(
            '姓名（可选）',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: AppConstants.neutralColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          TextFormField(
            controller: _nameController,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: '输入您的姓名',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              filled: true,
              fillColor: AppConstants.secondaryColor,
              prefixIcon: const Icon(Icons.person_outline),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing16,
                vertical: AppConstants.spacing12,
              ),
            ),
            validator: (value) {
              if (value != null && value.length > 50) {
                return '姓名必须少于50个字符';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.spacing16),
          const Text(
            '邮箱（可选）',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: AppConstants.neutralColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          TextFormField(
            controller: _emailController,
            maxLength: 100,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'your.email@example.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              filled: true,
              fillColor: AppConstants.secondaryColor,
              prefixIcon: const Icon(Icons.email_outlined),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing16,
                vertical: AppConstants.spacing12,
              ),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return '请输入有效的邮箱地址';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.spacing16),
          const Text(
            '您的反馈 *',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: AppConstants.neutralColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          TextFormField(
            controller: _feedbackController,
            maxLines: 8,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: '告诉我们您的想法...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              filled: true,
              fillColor: AppConstants.secondaryColor,
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.all(AppConstants.spacing16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '请输入您的反馈';
              }
              if (value.length < 10) {
                return '请提供更多详情（至少10个字符）';
              }
              if (value.length > 1000) {
                return '反馈必须少于1000个字符';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.spacing24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BCD4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                elevation: 4,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    '提交反馈',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherContactCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.contact_support,
                  color: Color(0xFF66BB6A),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '其他联系方式',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing20),
          _buildContactMethod(
            Icons.email,
            '邮件支持',
            'support@celva.app',
            '24小时内回复',
            const Color(0xFF4A90E2),
          ),
          const SizedBox(height: AppConstants.spacing16),
          _buildContactMethod(
            Icons.chat,
            '在线客服',
            '工作时间：上午9点 - 下午6点（太平洋时间）',
            '工作时间内即时支持',
            const Color(0xFF66BB6A),
          ),
          const SizedBox(height: AppConstants.spacing16),
          _buildContactMethod(
            Icons.forum,
            '社区论坛',
            'community.celva.app',
            '与其他用户交流',
            const Color(0xFFFF9800),
          ),
          const SizedBox(height: AppConstants.spacing16),
          _buildContactMethod(
            Icons.help,
            '帮助中心',
            'help.celva.app',
            '浏览常见问题和指南',
            const Color(0xFF9C27B0),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod(
    IconData icon,
    String title,
    String subtitle,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacing12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.neutralColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 56,
                  color: Color(0xFF66BB6A),
                ),
              ),
              const SizedBox(height: AppConstants.spacing20),
              const Text(
                '谢谢！',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading2,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
              const SizedBox(height: AppConstants.spacing12),
              Text(
                '您的反馈已成功提交。感谢您花时间帮助我们改进 约傍！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66BB6A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusMedium,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '完成',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _feedbackController.clear();
      setState(() {
        _selectedType = 'Bug Report';
        _selectedRating = 0;
      });
    }
  }
}
