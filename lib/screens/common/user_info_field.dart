import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/theme.dart';

/// 通用的资料项展示组件，左侧标题 + 右侧内容 + 箭头。
class UserInfoField extends StatelessWidget {
  const UserInfoField({
    super.key,
    this.onTap,
    required this.label,
    required this.value,
    this.highlightValue = false,
    this.highlightLabel = false,
  });

  /// 点击事件，可为空表示不可点击。
  final VoidCallback? onTap;

  /// 左侧文字标签。
  final String label;

  /// 右侧展示的文本。
  final String value;

  /// 右侧文本是否高亮显示。
  final bool highlightValue;

  /// 左侧文本是否高亮显示。
  final bool highlightLabel;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      color: highlightLabel ? Colors.white : AppColors.textFieldHint,
      fontSize: 14,
    );
    final valueStyle = TextStyle(
      color: highlightValue ? Colors.white : AppColors.textFieldHint,
      fontSize: 14,
    );

    final content = Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(24, 0, 18, 0),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, textAlign: TextAlign.center, style: labelStyle),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: valueStyle),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textFieldHint,
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
