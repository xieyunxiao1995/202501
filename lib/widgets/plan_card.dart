import 'package:flutter/material.dart';
import '../models/camp_model.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

/// Camp plan card widget
class PlanCard extends StatelessWidget {
  final CampPlan plan;
  final VoidCallback? onGearCheck;
  final VoidCallback? onShare;

  const PlanCard({
    super.key,
    required this.plan,
    this.onGearCheck,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        border: const Border(
          left: BorderSide(color: AppConstants.primaryColor, width: 4),
        ),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildPlanInfo(context)),
              _buildWeatherInfo(),
            ],
          ),
          const SizedBox(height: AppConstants.spacing16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onGearCheck,
                  icon: const Icon(Icons.checklist, size: 18),
                  label: const Text('Gear Check'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacing8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plan.title,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeHeading3,
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${plan.startDate.toShortDate()} - ${plan.endDate.toShortDate()}',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wb_sunny,
              size: 16,
              color: AppConstants.primaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              '${plan.temperature?.toInt() ?? '--'}°C',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(AppConstants.radiusRound),
          ),
          child: Text(
            _getStatusText(),
            style: TextStyle(
              fontSize: AppConstants.fontSizeCaption,
              color: Colors.green[700],
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText() {
    switch (plan.status) {
      case 'good_to_go':
        return 'Good to go';
      case 'check_weather':
        return 'Check weather';
      default:
        return 'In progress';
    }
  }
}
