import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppConstants.accentColor, size: 20),
              const SizedBox(width: AppConstants.spacing8),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeHeading3,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
          ],
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText!,
              style: TextStyle(
                fontSize: AppConstants.fontSizeCaption,
                color: Colors.grey[400],
              ),
            ),
          ),
      ],
    );
  }
}
