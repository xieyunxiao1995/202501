import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '《山海：洪荒纪元 隐私政策》',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '1. 信息收集',
                    '本游戏目前是一款纯单机本地运行的游戏，我们不会主动通过网络收集您的个人身份信息（如姓名、电话、身份证号等）。您的游戏进度、异兽数据等均仅存储在您的手机本地数据库中。',
                  ),
                  _buildSection(
                    '2. 权限说明',
                    '为了保证游戏的正常运行，我们可能需要以下权限：\n• 存储权限：用于保存和读取您的游戏存档。\n• 网络访问：仅用于检查版本更新（如有）及展示必要的系统通知。',
                  ),
                  _buildSection(
                    '3. 数据安全',
                    '由于数据存储在您的本地设备，数据的安全性主要取决于您对设备的管理。我们建议您定期通过设置中的“手动保存”功能保存进度，并避免随意删除应用缓存或重置系统。',
                  ),
                  _buildSection(
                    '4. 第三方服务',
                    '本游戏目前未集成任何第三方广告平台或分析工具。如果未来引入相关服务，我们将第一时间更新本政策并告知您。',
                  ),
                  _buildSection(
                    '5. 未成年人保护',
                    '我们非常重视未成年人的隐私保护。如果您是未成年人，请在监护人的陪同下阅读并使用本游戏。',
                  ),
                  _buildSection('6. 政策更新', '随着游戏的版本迭代，我们可能会不时更新本隐私政策。建议您定期查看。'),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      '更新日期：2024年12月25日',
                      style: TextStyle(
                        color: AppColors.textSub.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.bg,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        '隐私政策',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.03),
                width: 1,
              ),
            ),
            child: Text(
              content,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
