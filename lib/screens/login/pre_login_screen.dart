import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:zhenyu_flutter/screens/common/agreement_link.dart'; 
import 'package:zhenyu_flutter/screens/login/login.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class PreLoginScreen extends StatefulWidget {
  const PreLoginScreen({super.key});

  @override
  State<PreLoginScreen> createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends State<PreLoginScreen> {
  bool _isAgreed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/pre_login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            _buildConnectLint(context),
            Positioned(
              left: 0,
              right: 0,
              bottom: 100.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70.w),
                    child: StyledButton(
                      onPressed: () {
                        if (!_isAgreed) {
                          showMsg(context, '请阅读并同意《用户协议》和《隐私政策》');
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      gradient: AppGradients.primaryGradient,
                      borderRadius: BorderRadius.circular(65.r),
                      height: 90.h,
                      child: const Text('手机号码登录'),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildAgreementRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreementRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: _isAgreed,
          onChanged: (value) {
            setState(() {
              _isAgreed = value ?? false;
            });
          },
          activeColor: AppColors.goldGradientEnd,
          side: const BorderSide(color: Colors.white),
          checkColor: Colors.black,
        ),
        StyledText(
          '我已阅读并同意',
          fontSize: 24.sp,
          style: textStyleSecondary.copyWith(color: Colors.white),
        ),
        const AgreementLink(agreementKey: 'WEB_URL_USERAGREE'),
        StyledText(
          '和',
          fontSize: 24.sp,
          style: textStyleSecondary.copyWith(color: Colors.white),
        ),
        const AgreementLink(agreementKey: 'WEB_URL_PROTOCAL'),
      ],
    );
  }
}

Widget _buildConnectLint(BuildContext context) {
  return Positioned(
    top: MediaQuery.of(context).padding.top + 10.h,
    right: 20.w,
    child: TextButton(
      onPressed: () async {
        final Uri url = Uri.parse(
          'https://work.weixin.qq.com/kfid/kfc809d2bf7d3d5ccfc',
        );
        if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Text(
        '联系客服',
        style: TextStyle(color: Colors.white, fontSize: 28.sp),
      ),
    ),
  );
}
