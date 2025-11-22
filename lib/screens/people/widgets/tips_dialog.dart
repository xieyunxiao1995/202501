import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/theme.dart';

class TipsDialog extends StatelessWidget {
  final String? title;
  final String? text;
  final String? buttonText;
  final VoidCallback? onConfirm;

  const TipsDialog({
    super.key,
    this.title,
    this.text,
    this.buttonText,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTitle = title ?? '温馨提示';
    final defaultText =
        text ?? '为了维护良好的社交环境，请谨慎添加他人在聊天中主动发送的微信、QQ等外部联系方式，以防可能导致隐私泄露或财产损失的风险！';
    final defaultButtonText = buttonText ?? '我知道了';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 100.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // The main content box with background
          Container(
            margin: EdgeInsets.only(top: 50.r), // Space for the icon to overlap
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              // Placeholder for the background image
              color: const Color(0xFFF5F5DC), // A beige-like color
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 80.r), // Top padding inside the box
                  Text(
                    defaultTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 38.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30.r),
                  Text(
                    defaultText,
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: const Color(0xFF525053),
                    ),
                  ),
                  SizedBox(height: 65.r),
                  GestureDetector(
                    onTap: onConfirm ?? () => Navigator.of(context).pop(),
                    child: Container(
                      width: double.infinity,
                      height: 80.r,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primaryGradient,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          defaultButtonText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 28.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.r), // Bottom padding
                ],
              ),
            ),
          ),
          // The overlapping icon
          Positioned(
            top: 0,
            child: Container(
              width: 100.r,
              height: 100.r,
              child: Image.asset(
                'assets/images/tipsIcon.png',
                width: 100.r,
                height: 100.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
