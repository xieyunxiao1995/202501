import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/data.dart';

class EulaPage extends StatefulWidget {
  const EulaPage({super.key});

  @override
  State<EulaPage> createState() => _EulaPageState();
}

class _EulaPageState extends State<EulaPage> {
  final ScrollController _scrollController = ScrollController();
  bool _canAgree = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Detect if scrolled to the bottom
    if (!_canAgree &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50) {
      setState(() {
        _canAgree = true;
      });
    }
  }

  void _handleAgree() {
    if (!_canAgree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先完整阅读协议后再接受。'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Update global state if you have EULA check in AppState (Optional based on your logic)
    // AppState.instance.setEulaAgreed(true);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('用户协议'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Information Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '请仔细阅读以下协议，滚动到底部即可接受。',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Agreement Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('MoodStyle 用户协议'),
                    const SizedBox(height: 8),
                    Text(
                      '最后更新：2026年2月25日',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('一、协议的接受与修改'),
                    _buildParagraph(
                      '1.1 欢迎使用 MoodStyle（以下简称"本应用"）。通过访问和使用本应用，您确认已阅读、理解并同意受本协议所有条款的约束。',
                    ),
                    _buildParagraph(
                      '1.2 我们有权随时修改本协议。当发生变更时，我们将通过应用内通知的方式告知您。您继续使用本应用即视为接受修改后的协议。',
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('二、提供的服务'),
                    _buildParagraph('2.1 MoodStyle 是一款穿搭记录与分享应用。主要功能包括：'),
                    _buildBulletPoint('记录个人穿搭日记'),
                    _buildBulletPoint('浏览和分享穿搭内容'),
                    _buildBulletPoint('获取穿搭灵感与建议'),
                    _buildBulletPoint('管理个人衣橱'),
                    _buildParagraph('2.2 我们致力于提供高质量的穿搭记录体验，但不保证服务完全无误或不中断。'),
                    const SizedBox(height: 16),
                    _buildSectionTitle('AI 智能穿搭功能说明'),
                    _buildParagraph(
                      '2.3 本应用集成了 AI 智能穿搭推荐功能，通过人工智能技术为用户提供个性化的穿搭建议。',
                    ),
                    _buildBulletPoint('小搭：通过对话形式获取您的穿搭需求，提供专业搭配建议'),
                    _buildBulletPoint('AI 推荐算法：基于场景、风格、天气等因素生成个性化穿搭方案'),
                    _buildBulletPoint('AI 生成内容：部分穿搭推荐由 AI 自动生成，仅供参考'),
                    _buildParagraph('2.4 AI 功能说明：'),
                    _buildBulletPoint('AI 推荐仅供参考，不构成任何专业建议或承诺'),
                    _buildBulletPoint('AI 可能会生成不准确或不适当的内容，请理性判断'),
                    _buildBulletPoint('我们持续优化 AI 模型，但无法保证 100% 准确性'),
                    _buildBulletPoint('使用 AI 功能即表示您理解并接受上述说明'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('三、用户账号'),
                    _buildParagraph('3.1 本应用采用简化登录方式，无需注册账号和密码。'),
                    _buildParagraph('3.2 您的使用数据将存储在本地设备上，请妥善保管您的设备。'),
                    _buildParagraph('3.3 如果您更换设备或清除应用数据，之前的记录可能会丢失。'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('四、用户行为规范'),
                    _buildParagraph('4.1 在使用本应用时，您应遵守相关法律法规，不得利用本应用从事任何违法活动。'),
                    _buildParagraph('4.2 您发布的内容应真实、健康、积极，不得包含：'),
                    _buildBulletPoint('违反法律法规的内容'),
                    _buildBulletPoint('侵犯他人知识产权的内容'),
                    _buildBulletPoint('虚假、欺诈、诽谤或骚扰性内容'),
                    _buildBulletPoint('商业广告或推广信息'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('五、隐私保护'),
                    _buildParagraph('5.1 我们尊重并保护您的隐私，收集的数据仅用于提供和改进服务。'),
                    _buildParagraph(
                      '5.2 您的穿搭记录、照片等个人数据仅存储在您的本地设备上，未经您同意我们不会分享给第三方。',
                    ),
                    _buildParagraph(
                      '5.3 我们可能会收集匿名的使用统计数据以改善产品体验，这些数据无法追溯到您的个人身份。',
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('六、知识产权'),
                    _buildParagraph(
                      '6.1 本应用的所有内容（包括但不限于应用本身、代码、设计、商标、文字和图片）均受知识产权法保护。',
                    ),
                    _buildParagraph(
                      '6.2 您对自己发布的原创内容保留知识产权，但您授权我们在应用内展示和分发这些内容。',
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('七、免责声明'),
                    _buildParagraph('7.1 本应用按"现状"提供，不对其适用性或特定用途的适用性提供任何保证。'),
                    _buildParagraph('7.2 对于因不可抗力、网络故障或系统维护导致的服务中断，我们不承担责任。'),
                    _buildParagraph('7.3 对于您因使用本应用而可能遭受的任何损害，我们不承担责任。'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('八、协议终止'),
                    _buildParagraph('8.1 您可以随时停止使用本应用，届时本协议即告终止。'),
                    _buildParagraph('8.2 如果您违反本协议，我们有权终止您对服务的使用权限。'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('九、争议解决'),
                    _buildParagraph('9.1 本协议的解释、效力及纠纷的解决，适用相关法律法规。'),
                    _buildParagraph(
                      '9.2 若发生争议，双方应友好协商解决；协商不成的，任何一方均可向有管辖权的法院提起诉讼。',
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('十、其他条款'),
                    _buildParagraph('10.1 本协议构成双方就本协议标的所达成的完整协议。'),
                    _buildParagraph('10.2 如果本协议的任何条款被认定为无效，不影响其他条款的效力。'),
                    _buildParagraph('10.3 我们未能执行本协议的任何权利，不构成对该权利的放弃。'),
                    const SizedBox(height: 32),
                    _buildSectionTitle('联系我们'),
                    _buildParagraph('如果您对本协议有任何疑问，请通过应用内的反馈功能联系我们。'),
                    const SizedBox(height: 40),
                    // Agree Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _canAgree ? _handleAgree : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canAgree
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          foregroundColor: _canAgree
                              ? Colors.white
                              : Colors.grey.shade500,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _canAgree ? '同意并接受' : '请完整阅读协议',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: AppColors.primary, fontSize: 14),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
