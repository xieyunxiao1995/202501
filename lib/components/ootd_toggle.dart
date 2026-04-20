import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class OotdToggle extends StatelessWidget {
  final bool isOotd;
  final ValueChanged<bool> onOotdChanged;

  const OotdToggle({
    super.key,
    required this.isOotd,
    required this.onOotdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onOotdChanged(!isOotd),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isOotd ? AppColors.primary.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOotd ? AppColors.primary : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isOotd ? AppColors.primary : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.checkroom_rounded,
                color: isOotd ? AppColors.textMain : Colors.grey.shade500,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '今日穿搭',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isOotd ? '已标记为今日穿搭' : '标记为今日穿搭',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isOotd ? AppColors.primary : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                isOotd ? Icons.check_rounded : Icons.add_rounded,
                color: isOotd ? AppColors.textMain : Colors.grey.shade600,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
