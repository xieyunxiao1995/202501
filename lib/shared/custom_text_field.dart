import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.prefixText,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.suffix,
    this.obscureText = false,
  });

  final String prefixText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Widget? suffix;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 20.w),
          SizedBox(
            width: 120.w,
            child: Center(
              child: Text(
                prefixText,
                style: TextStyle(
                  color: AppColors.textFieldHint,
                  fontSize: 27.sp,
                ),
              ),
            ),
          ),
          Text(
            '|',
            style: TextStyle(color: AppColors.textFieldHint, fontSize: 27.sp),
          ),
          SizedBox(width: 30.w),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,
              obscureText: obscureText,
              style: TextStyle(color: AppColors.textFieldHint, fontSize: 27.sp),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColors.textFieldHint,
                  fontSize: 27.sp,
                ),
                border: InputBorder.none,
                counterText: '', // Hide the counter
              ),
            ),
          ),
          if (suffix != null) suffix!,
          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}
