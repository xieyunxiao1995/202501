import 'package:flutter/material.dart';

/// 隐私政策页面
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030408),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('隐私政策'),
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
        padding: const EdgeInsets.all(20),
        child: _buildPrivacyContent(),
      ),
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '隐私保护政策',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '更新日期：2025年4月1日',
          style: const TextStyle(fontSize: 12, color: Color(0xFF667788)),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF00F0FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.3)),
          ),
          child: const Text(
            '我们非常重视您的隐私。本政策说明了我们如何收集、使用、存储和保护您的个人信息。',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFFAABBCC),
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildSection(
          '一、信息收集',
          '1.1 我们可能收集的信息类型：\n'
              '• 设备信息：设备型号、操作系统版本、唯一设备标识符\n'
              '• 使用数据：游戏时长、关卡进度、游戏内操作记录\n'
              '• 账号信息：游戏昵称、头像、等级数据\n\n'
              '1.2 我们不会收集的信息：\n'
              '• 您的真实姓名、电话号码、地址等个人敏感信息\n'
              '• 通讯录、相册、麦克风等敏感权限数据',
        ),
        _buildSection(
          '二、信息使用',
          '2.1 我们收集的信息将用于以下目的：\n'
              '• 提供和优化游戏服务体验\n'
              '• 保存游戏进度和数据\n'
              '• 分析和改进游戏性能\n'
              '• 防止欺诈和滥用行为\n\n'
              '2.2 我们不会将您的个人信息出售、出租或以其他方式提供给第三方用于营销目的。',
        ),
        _buildSection(
          '三、信息存储与安全',
          '3.1 我们采取合理的安全措施来保护您的个人信息不被未经授权的访问、使用或泄露。\n\n'
              '3.2 游戏数据可能存储在本地设备或云端服务器，我们会定期备份以防止数据丢失。\n\n'
              '3.3 我们不会将您的个人信息传输至境外服务器。',
        ),
        _buildSection(
          '四、信息共享与披露',
          '4.1 在以下情况下，我们可能会披露您的信息：\n'
              '• 应法律法规要求或政府机关的合法要求\n'
              '• 为保护本游戏的合法权益\n'
              '• 为防止对用户或公众的紧急伤害\n\n'
              '4.2 除上述情况外，我们不会向任何第三方共享您的个人信息。',
        ),
        _buildSection(
          '五、您的权利',
          '5.1 您有权：\n'
              '• 查询、更正您的个人信息\n'
              '• 要求删除您的游戏数据\n'
              '• 撤回对信息收集的同意\n'
              '• 注销游戏账号\n\n'
              '5.2 您可以通过游戏内的"反馈与建议"功能联系我们行使上述权利。',
        ),
        _buildSection(
          '六、未成年人保护',
          '6.1 我们鼓励父母或监护人对未成年人的游戏行为进行引导和监督。\n\n'
              '6.2 如果监护人发现未成年人沉迷游戏，可以联系我们采取相应措施。',
        ),
        _buildSection(
          '七、政策的变更',
          '7.1 我们可能会不时更新本隐私政策。更新后的政策将在游戏内公布。\n\n'
              '7.2 对于重大变更，我们将通过游戏内公告或其他合理方式通知您。',
        ),
        const SizedBox(height: 30),
        Center(
          child: Text(
            '— 隐私政策结束 —',
            style: const TextStyle(fontSize: 13, color: Color(0xFF445566)),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00F0FF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFAABBCC),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
