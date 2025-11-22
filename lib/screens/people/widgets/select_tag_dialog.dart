import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/theme.dart';

class SelectTagDialog extends StatefulWidget {
  final List<String> tags;
  final String? selectedTag;

  const SelectTagDialog({super.key, required this.tags, this.selectedTag});

  @override
  State<SelectTagDialog> createState() => _SelectTagDialogState();
}

class _SelectTagDialogState extends State<SelectTagDialog> {
  late String? _currentlySelectedTag;

  @override
  void initState() {
    super.initState();
    _currentlySelectedTag = widget.selectedTag;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.textFieldBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(), _buildTagGrid(), _buildActionButtons()],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
      ),
      child: Center(
        child: Text(
          '选择标签',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 32.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildTagGrid() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Wrap(
        spacing: 20.w,
        runSpacing: 20.h,
        children: widget.tags.map((tag) {
          final isSelected = _currentlySelectedTag == tag;
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentlySelectedTag = tag;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: isSelected ? AppGradients.primaryGradient : null,
                color: isSelected
                    ? null
                    : const Color.fromRGBO(255, 255, 255, 0.08),
                borderRadius: BorderRadius.circular(83.r),
                border: Border.all(
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 25.sp,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildButton(
            '取消',
            isConfirm: false,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          _buildButton(
            '确定',
            isConfirm: true,
            onTap: () {
              Navigator.of(context).pop(_currentlySelectedTag);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text, {
    required bool isConfirm,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.w,
        height: 60.h,
        decoration: BoxDecoration(
          gradient: isConfirm ? AppGradients.primaryGradient : null,
          color: isConfirm ? null : AppColors.btnText,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isConfirm ? AppColors.textFieldBackground : Colors.white,
              fontSize: 28.sp,
            ),
          ),
        ),
      ),
    );
  }
}
