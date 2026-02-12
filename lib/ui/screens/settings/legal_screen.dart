import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants.dart';

enum LegalType { terms, privacy }

class LegalScreen extends StatelessWidget {
  final String title;
  final LegalType type;

  const LegalScreen({super.key, required this.title, required this.type});

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
        title: Text(title, style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: isSmallScreen ? 24 : 28)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type == LegalType.terms ? '用户协议' : '隐私政策',
              style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              '更新日期：2026年2月5日',
              style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 12 : 14, color: Colors.grey),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.woodDark.withOpacity(0.1)),
              ),
              child: Text(
                _getContent(),
                style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 14 : 16, height: 1.8, color: AppColors.inkBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getContent() {
    if (type == LegalType.terms) {
      return '''
1. 服务条款的接受
欢迎使用《山海墨世》（以下简称“本游戏”）。请您仔细阅读本《用户协议》（以下简称“本协议”）。当您开始使用本游戏时，即表示您已同意接受本协议的所有条款。

2. 账号注册与使用
您需要注册一个账号来使用本游戏的部分功能。您有责任妥善保管您的账号信息，并对该账号下的所有活动负责。

3. 用户行为规范
您同意在使用本游戏时遵守法律法规，不发布违法、违规、暴力、色情等不良信息。不使用外挂、脚本等破坏游戏公平性的手段。

4. 知识产权声明
本游戏包含的所有文本、图片、音频、代码等内容均受版权法保护。未经许可，任何第三方不得擅自复制、转载或用于商业用途。

5. 免责声明
本游戏按“现状”提供，我们不保证服务不会中断或没有错误。对于因网络问题、设备故障等原因导致的游戏数据丢失，我们不承担责任，但会尽力协助恢复。

6. 协议修改
我们保留随时修改本协议的权利。修改后的协议将在游戏中公布，继续使用本游戏即视为您接受修改后的协议。
''';
    } else {
      return '''
1. 信息收集
为了提供更好的游戏体验，我们可能会收集您的设备信息（如型号、系统版本）、游戏数据（如进度、成就）以及您主动提供的反馈信息。

2. 信息使用
收集的信息将用于：
- 优化游戏性能和修复Bug
- 提供个性化的游戏内容
- 处理您的客户服务请求
- 分析用户行为以改进产品

3. 信息共享
我们不会将您的个人信息出售给第三方。但在以下情况下，我们可能会共享信息：
- 获得您的明确同意
- 法律法规要求或政府机关指令
- 保护我们的合法权益

4. 数据安全
我们采取合理的技术手段保护您的数据安全，防止未经授权的访问、使用或泄露。但请注意，互联网传输并非绝对安全。

5. 未成年人保护
我们非常重视未成年人的隐私保护。若您是未成年人，请在监护人的陪同下阅读本政策，并由监护人同意后使用本游戏。

6. 联系我们
如果您对本隐私政策有任何疑问，请通过设置页面中的“反馈与建议”联系我们。
''';
    }
  }
}
