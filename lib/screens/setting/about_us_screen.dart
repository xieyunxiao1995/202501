import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/config/config.dart';
import 'package:zhenyu_flutter/screens/common/webview_screen.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  void _navigateToWebView(BuildContext context, String key) {
    final docInfo = AppDocs.docData[key];
    if (docInfo == null) return;

    final title = docInfo['tit'] ?? '';
    final urlPath = docInfo['url'] ?? '';
    final fullUrl = '${AppDocs.docUrl}$urlPath?appName=真遇';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: fullUrl, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // const appVersion = 'V1.0.0';

    return Scaffold(
      appBar: AppBar(
        title: const StyledText('关于我们', fontSize: 18),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/logo.png', width: 120, height: 120),
            // const SizedBox(height: 10),
            // const StyledText(appVersion),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: AppColors.tabBarBackground,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(
                children: [
                  _buildMenuItem(context, '用户协议', 'WEB_URL_USERAGREE'),
                  _buildMenuItem(context, '隐私政策', 'WEB_URL_PROTOCAL'),
                  _buildMenuItem(context, '充值协议', 'WEB_URL_PAY'),
                  _buildMenuItem(context, '会员协议', 'WEB_URL_VIP'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String key) {
    return GestureDetector(
      onTap: () => _navigateToWebView(context, key),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledText(title, fontSize: 13),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
