import 'package:flutter/material.dart';
import '../widgets/background_wrapper.dart';

class UserAgreementScreen extends StatelessWidget {
  final VoidCallback onClose;

  const UserAgreementScreen({super.key, required this.onClose});

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
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: isSmallScreen ? 20 : 24),
          onPressed: onClose,
        ),
        title: Text(
          "用户协议",
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
            _buildHeader("大荒协议", isSmallScreen),
            const SizedBox(height: 8),
            Text(
              "最后更新：2026年1月15日",
              style: TextStyle(color: Colors.white54, fontSize: isSmallScreen ? 11 : 12),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "1. 接受协议",
              "欢迎使用山海地牢。使用本应用即表示您同意遵守本用户协议的所有条款和条件。如果您不同意本协议的任何部分，请勿使用本应用。",
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "2. 使用规则",
              "本应用仅供个人娱乐使用。您不得：\n"
                  "- 将本应用用于商业目的\n"
                  "- 逆向工程、反编译或反汇编本应用\n"
                  "- 未经授权复制、修改或分发本应用\n"
                  "- 利用本应用进行任何非法活动",
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "3. 用户行为",
              "您同意在使用本应用时遵守所有适用的法律法规。您对通过您的账户进行的所有活动负责。",
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "4. 内容所有权",
              "本应用中的所有内容，包括但不限于文本、图形、图像、代码和设计，均为 Shanhai Games 或其许可方的财产，受版权法和其他知识产权法保护。",
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "5. 免责声明",
              "本应用按“原样”提供，不提供任何明示或暗示的保证，包括但不限于适销性、特定用途适用性和非侵权性的保证。Shanhai Games 不保证本应用将不间断、及时、安全或无错误。",
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "6. 责任限制",
              "在任何情况下，Shanhai Games 均不对任何直接、间接、附带、特殊、后果性或惩罚性损害负责，包括但不限于利润损失、数据丢失、商誉损失或其他无形损失。",
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "7. 协议变更",
              "Shanhai Games 保留随时修改本协议的权利。修改后的协议将在本应用上发布时生效。继续使用本应用即表示您接受修改后的协议。",
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "8. 适用法律",
              "本协议受中华人民共和国法律管辖，并按其解释。任何因本协议引起的争议应提交至有管辖权的法院解决。",
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "9. 联系我们",
              "如果您对本协议有任何疑问，请通过以下方式联系我们：\n"
                  "邮箱：legal@shanhaigames.com\n"
                  "地址：中国·上海市浦东新区张江高科技园区",
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber, size: isSmallScreen ? 20 : 24),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    "重要提示",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: isSmallScreen ? 13 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    "请仔细阅读本协议。使用本应用即表示您已理解并同意本协议的所有条款。",
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
