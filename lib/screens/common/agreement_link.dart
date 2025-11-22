import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/config/config.dart';
import 'package:zhenyu_flutter/screens/common/webview_screen.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';

class AgreementLink extends StatelessWidget {
  final String agreementKey;
  final TextStyle? style;

  const AgreementLink({super.key, required this.agreementKey, this.style});

  @override
  Widget build(BuildContext context) {
    final docInfo = AppDocs.docData[agreementKey];
    if (docInfo == null) {
      return const SizedBox.shrink();
    }

    final title = docInfo['tit'] ?? '';
    final urlPath = docInfo['url'] ?? '';
    final fullUrl = '${AppDocs.docUrl}$urlPath?appName=真遇';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WebViewScreen(url: fullUrl, title: title),
          ),
        );
      },
      child: StyledText(
        '《$title》',
        fontSize: 24.sp,
        style: style ?? const TextStyle(color: AppColors.goldGradientEnd),
      ),
    );
  }
}
