import 'package:flutter/material.dart';
import '../widgets/background_wrapper.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final VoidCallback onClose;

  const PrivacyPolicyScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white70,
              size: isSmallScreen ? 20 : 24,
            ),
            onPressed: onClose,
          ),
          title: Text(
            "隐私协议",
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader("遁世密约", isSmallScreen),
              const SizedBox(height: 8),
              Text(
                "最后更新：2026年1月15日",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: isSmallScreen ? 11 : 12,
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildSection(
                "1. 引言",
                "Shanhai Games（以下简称“我们”）深知个人信息对您的重要性，并会尽全力保护您的个人信息安全可靠。我们致力于维持您对我们的信任，恪守以下原则，保护您的个人信息：权责一致原则、目的明确原则、选择同意原则、最少够用原则、确保安全原则、主体参与原则、公开透明原则等。",
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildSection(
                "2. 信息收集",
                "我们不会收集任何个人身份信息，包括但不限于：\n"
                    "- 姓名、地址、电话号码\n"
                    "- 电子邮件地址\n"
                    "- 社交媒体账户信息\n"
                    "- 位置信息\n"
                    "- 生物识别信息\n\n"
                    "所有游戏进度数据均存储在您的设备本地，不会上传至任何服务器。",
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildSection(
                "3. 数据使用",
                "由于我们不收集任何个人数据，因此不会将您的个人信息用于任何商业目的。游戏内的所有数据仅用于：\n"
                    "- 保存游戏进度（本地存储）\n"
                    "- 提供游戏体验\n"
                    "- 生成游戏统计数据（本地计算）",
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildSection(
                "4. 第三方服务",
                "本应用不使用任何第三方服务，包括但不限于：\n"
                    "- 分析工具（如 Google Analytics）\n"
                    "- 广告服务\n"
                    "- 社交媒体集成\n"
                    "- 云存储服务\n"
                    "- 推送通知服务",
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildSection(
                "5. 数据安全",
                "我们采取适当的安全措施来保护您的数据：\n"
                    "- 所有数据存储在您的设备本地\n"
                    "- 不进行网络传输\n"
                    "- 不与第三方共享数据\n"
                    "- 定期更新安全措施",
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildSection(
                "6. 数据访问与控制",
                "由于所有数据均存储在您的设备本地，您拥有完全的控制权：\n"
                    "- 您可以随时访问您的游戏数据\n"
                    "- 您可以随时删除游戏数据\n"
                    "- 您可以导出游戏数据\n"
                    "- 您可以清除应用缓存",
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildSection(
                "7. 儿童隐私",
                "本应用不收集任何个人信息，因此特别适合儿童使用。我们不会故意收集未满 13 岁儿童的个人信息。",
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildSection(
                "8. 隐私政策变更",
                "我们可能会不时更新本隐私政策。更新后的政策将在本应用上发布，并标注生效日期。继续使用本应用即表示您接受更新后的隐私政策。",
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              _buildSection(
                "9. 联系我们",
                "如果您对本隐私政策有任何疑问或建议，请通过以下方式联系我们：\n"
                    "邮箱：privacy@shanhaigames.com\n"
                    "地址：中国·上海市浦东新区张江高科技园区\n\n"
                    "我们将在收到您的反馈后尽快回复。",
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 24 : 32),
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      color: Colors.green,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Text(
                      "隐私承诺",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: isSmallScreen ? 13 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Text(
                      "我们承诺保护您的隐私，不收集任何个人数据。",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 11 : 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 24 : 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title, bool isSmallScreen) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.amber,
        fontSize: isSmallScreen ? 20 : 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 15 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 13 : 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
