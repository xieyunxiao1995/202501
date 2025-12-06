import 'package:flutter/material.dart';
import '../models/gear_model.dart';
import '../utils/constants.dart';

/// Gear item card widget
class GearCard extends StatelessWidget {
  final GearItem item;
  final ValueChanged<bool>? onChecked;

  const GearCard({super.key, required this.item, this.onChecked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Opacity(
        opacity: item.isPacked ? 0.6 : 1.0,
        child: Row(
          children: [
            // Emoji icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Center(
                child: Text(item.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: AppConstants.spacing12),
            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.neutralColor,
                      decoration: item.isPacked
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (item.description != null)
                    Text(
                      item.description!,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeCaption,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            // Checkbox
            _buildCheckbox(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: () => onChecked?.call(!item.isPacked),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: item.isPacked
                ? AppConstants.primaryColor
                : Colors.grey[300]!,
            width: 2,
          ),
          color: item.isPacked ? AppConstants.primaryColor : Colors.transparent,
        ),
        child: item.isPacked
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}
