import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/screens/invate/invate_screen.dart';
import 'package:zhenyu_flutter/screens/vip/vip_screen.dart';
import 'package:zhenyu_flutter/shared/gradient_text.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/theme.dart';

class VipDialog extends StatelessWidget {
  final String? title;
  final String? text;
  // In a real app, you might pass the user's sex or the full user object
  // to determine the default text. For now, we'll just allow overriding.
  final bool isMale = true; // Placeholder

  const VipDialog({super.key, this.title, this.text});

  @override
  Widget build(BuildContext context) {
    final defaultTitle = title ?? '开通VIP无限畅聊';
    final defaultText = text ?? (isMale ? '解锁筛选与搜索,同时解锁联系方式' : '解锁筛选与搜索,同时私聊');

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogContent(context, defaultTitle, defaultText),
            SizedBox(height: 20.h),
            _buildCloseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context, String title, String text) {
    return Container(
      width: 604.w,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(31.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientText(
            title,
            gradient: AppGradients.primaryGradient,
            style: TextStyle(fontSize: 46.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          Text(
            text,
            style: textStylePrimary.copyWith(
              fontSize: 31.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 50.h),
          StyledButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const VipScreen()));
            },
            width: 520.w,
            height: 83.h,
            borderRadius: BorderRadius.circular(83.r),
            gradient: AppGradients.primaryGradient,
            child: Text(
              '开通会员',
              style: TextStyle(
                fontSize: 27.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          StyledButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const InvateScreen()));
            },
            width: 520.w,
            height: 83.h,
            borderRadius: BorderRadius.circular(83.r),
            gradient: AppGradients.primaryGradient,
            child: Text(
              '邀请2人注册，获得3天会员',
              style: TextStyle(
                fontSize: 27.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 30),
      ),
    );
  }
}
